"""Cached bidirectional motion with occlusion rejection for transparent sprites."""
import cv2
import numpy as np
from PIL import Image

_cache = {}


def interpolate(first, second, t):
    key = (id(first), id(second))
    if key not in _cache:
        a = np.asarray(first, dtype=np.float32) / 255
        b = np.asarray(second, dtype=np.float32) / 255
        a[:, :, :3] *= a[:, :, 3:4]
        b[:, :, :3] *= b[:, :, 3:4]
        def gray(im):
            return np.uint8(np.clip((cv2.cvtColor(im[:, :, :3], cv2.COLOR_RGB2GRAY)
                                    * .7 + im[:, :, 3] * .3) * 255, 0, 255))
        ga, gb = gray(a), gray(b)
        dis = cv2.DISOpticalFlow_create(cv2.DISOPTICAL_FLOW_PRESET_MEDIUM)
        _cache[key] = a, b, dis.calc(ga, gb, None), dis.calc(gb, ga, None)
    a, b, forward, backward = _cache[key]
    y, x = np.mgrid[:a.shape[0], :a.shape[1]].astype(np.float32)
    left = cv2.remap(a, x-t*forward[:, :, 0], y-t*forward[:, :, 1], cv2.INTER_LINEAR)
    right = cv2.remap(b, x-(1-t)*backward[:, :, 0], y-(1-t)*backward[:, :, 1], cv2.INTER_LINEAR)
    blended = left*(1-t) + right*t
    # Disoccluded hands, feet and snake heads must not produce two translucent bodies.
    conflict = np.abs(left[:, :, 3]-right[:, :, 3]) > .08
    conflict |= np.max(np.abs(left[:, :, :3]-right[:, :, :3]), axis=2) > .12
    blended[conflict] = (left if t < .5 else right)[conflict]
    blended[:, :, :3] /= np.maximum(blended[:, :, 3:4], 1/255)
    return Image.fromarray(np.uint8(np.clip(blended*255, 0, 255)))
