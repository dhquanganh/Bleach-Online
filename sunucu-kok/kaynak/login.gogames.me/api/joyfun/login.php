<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

    <head>
        <title> Joyfun《死神狂潮》【server- S974】   </title>
        <meta name="google" value="notranslate" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="./js/jquery.min.js"></script>
		<script type="text/javascript" src="../js/swfobject.js"></script>
		<script type="text/javascript" src="../js/doResize.js"></script>
		<script type="text/javascript" src="https://cdn.gogames.me/js/official/trackcode.js"></script>
		<script type="text/javascript" src="https://cdn.gogames.me/js/official/bleach/game_call_pay.js?20140729"></script>
		<style type="text/css">
			/** 层样式 **/
			.close {
				float: right;
				height: 40px;
				width: 40px;
				cursor: pointer;
				margin-top: 15px;
				margin-right: 5px;
				background: url("../image/close_01.png") 0 0 no-repeat;
			}

			.close:HOVER {
				background: url("../image/close_02.png") 0 0 no-repeat;
			}

			.rechargeDiv {
				background:#FFF;
				padding:10px;
				border:3px solid #666;
				height: 300px;
				width: 400px;
				left:700px;/*FF IE7*/
				top: 110px;/*FF IE7*/
				margin-top:0px;
				position:absolute;/*IE6*/
			}
			.rechargeDiv table {
				width:100%;
			}
			.rechargeDiv td {
				font-size:14px;
				color:#333;
				padding:5px 0;
				text-align:left;
			}
			.rechargeDiv input,textarea {
				font-size:14px;
				color:#333;
			}
			.rechargeDiv caption {
				font-size:18px;
				color:#333;
				text-align:center;
				border:3px dashed #999;
				border-width:0 0 1px 0;
				padding:5px 0 10px 0;
			}
			.rechargeDiv button{
				font-size:14px;
				color:#333;
				margin-right:20px;
			}
			.dhBtn {
				margin-top: 0px;
				padding-top: 6px;
				text-align: center;
				cursor: pointer;
				background: url("../image/btn_01.png") 0 0 no-repeat;
				height: 26px;
				width: 101px;
				color: #FBFFDE;
				font-size: 12px;
			}
			.dhBtn:hover {
				background: url("../image/btn_02.png") 0 0 no-repeat;
			}

			.rrPrice {
				font-size: 12px;
				color: #f0dac2;
			}

			.rechargeTip {
				font-size: 12px;
				color: #ab9057;
				text-align: center;
			}

			.rechargeInput {
				font-size: 12px;
				color: #c7a47a;
				text-align: center;
			}

			.rechargeInputTxt {
				background-color: #1A160D;
				border: solid 1px #796042;
				width: 83px;
				color: #ffffff;
			}


			.official {
				font-size: 18px;
			}

			#background {position:absolute; z-index:998; top:0px; left:0px; background:rgb(50,50,50);background:rgba(0,0,0,0.5); display:none;}
			#content {position:absolute; width:683px; height:514px; z-index:999; padding:18px 0 0 9px;  background:url(../images/bg_announce.gif) 0 0 no-repeat; border-radius:5px; display:none;}
			#title {width:679px; height:19px;}
			#title .closebtn {float:right; width:28px; height:19px; background:url(../images/btn_close.gif) 0 0 no-repeat;}
			#title .closebtn:hover {background:url(../images/btn_close_hover.gif) 0 0 no-repeat;}
			#title .closebtn img {cursor:pointer; border:0;}
			#content .l_pic {float:left; width:188px; padding:10px 0 0 10px;}
			#content .r_txt {float:left; width:450px; height:365px; overflow:auto; margin:85px 0 0 15px; font-size:12px; color:#f39800;}

		</style>

        <style type="text/css" media="screen">
            *		{font-family:微软雅黑,Tahoma;font-size: 12px;color: #FFF; line-height:22px;}
            a		{color:#FFF;text-decoration:none}
            a:hover	{color:#FFF; text-decoration:underline}
            html, body  { height:100%; }
            body { margin:0; padding:0; overflow:auto; text-align:center;
                   background-color: #000000; }
            object:focus { outline:none; }
            #flashContent { display:none; }
            #foot { margin:0; padding:0; overflow:auto; text-align:center; }
        </style>
      <script type="text/javascript">
            var favorite = "您的浏览器不支持此功能，请按'Ctrl + D'键加入收藏";
            window.onbeforeunload = function(){
                exitGame(document.title,window.location);
            }

            function addBookmark(title,url){
                if (document.all){
                    window.external.addFavorite(url,title);
                }else if (window.sidebar){
                    window.sidebar.addPanel(title, url, "");
                }else
                {
                    alert(favorite);
                }
            }
            function getcookie(name){
                   var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
                   if (arr != null){
                        return unescape(arr[2]);
                   } return "fail";
            }
            function setcookie(cookieName, cookieValue, day, path, domain, secure) {
                var expires = new Date();
                expires.setTime(expires.getTime() + day*24*60*60*1000);
                document.cookie = escape(cookieName) + '=' + escape(cookieValue)
                    + (expires ? '; expires=' + expires.toGMTString() : '')
                    + (path ? '; path=' + path : '/')
                    + (domain ? '; domain=' + domain : '')
                    + (secure ? '; secure' : '');
            }

            function exitGame(title,url){
              if(getcookie("isAddMark") == "fail"){
                    setcookie("isAddMark","add",365);
                    addBookmark(title,url);
              }
            }

            //lastlogin
            function lastLoginServ(sId){
              var ls = getcookie("bleach_games_login");

              if( ls == "fail"){
                    setcookie("bleach_games_login",sId,365);
              }else{

              	  ls = ls + "," + sId;
				  setcookie("bleach_games_login",ls,365);
              }
            }

			function recharge() {
				$('#popDiv').css('display','block');
			}

			function subFeedback()
			{
				var title = $('#feedbackTit').val();
				if(!title) {
					alert('input title');
					return false;
				}
				if(title.length > 20) {
					alert('the title between 1 - 20 chars');
					return false;
				}
				var content = $('#feedbackCot').val();
				if(!content) {
					alert('input content');
					return false;
				}
				if(content.length > 100) {
					alert('content chars too longer');
					return false;
				}
				var server = 974;
				var agent = 54;
				var suid = "352354512635355";
				var url = "../faq.php?sid=" + server + "&aid=" + agent + "&suid=" + suid + "&title=" + title + "&content=" + content;
				$.get(url, function(data){
					switch(parseInt(data)) {
						case -1 : alert('failed'); break;
						case 0 : alert('failed'); break;
						case 1 : alert('success'); break;
					}
					$('#feedbackTit').val('');
					$('#feedbackCot').val('');
					$('#popDiv').css('display','none');
				});
			}

        </script>

        <!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
        <!-- BEGIN Browser History required section >
        <link rel="stylesheet" type="text/css" href="history/history.css" />
        <script type="text/javascript" src="history/history.js"></script>
        <! END Browser History required section -->
    </head>
    <body style="" onload="doResize();" >
		<div id="background"></div>
		<div id="content">

			<div id="title"><a class="closebtn" id="close" href="#"><img src="../images/spacer.gif" /></a></div>

			<!-- 左侧图片 -->
			<div class="l_pic"><img src="../images/1-1.jpg" /></div>

			<!-- 右侧内容区 -->
			<div class="r_txt">

			</div>
		</div>

		<div id="popDiv" class="rechargeDiv" style="display:none;">
			<table>
				<caption>Feedback</caption>
				<tr><td>title</td><td><input type="text" id="feedbackTit" style="width:290px;" maxlength="20" /></td></tr>
				<tr><td>content</td><td><textarea id="feedbackCot" style="width:290px; height:100px;" maxlength="100" ></textarea></td></tr>
				<tr><td> </td><td><span style="color:red;">100 chars</span></td></tr>
				<tr><td> </td><td><button onclick="subFeedback();">submit</button><button onclick="$('#popDiv').css('display','none');" >cancel</button></td></tr>
				<tr></tr>
			</table>
		</div>

        <!-- <script type="text/javascript" src="http://game.weibo.com/static/js/v0.3/wyx.connect.js.php"> -->
		</script>

        <script type="text/javascript">
            // For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection.
            var swfVersionStr = "0.0.0";
            // To use express install, set to playerProductInstall.swf, otherwise the empty string.
            var xiSwfUrlStr = "https://login.gogames.me/public/2026090619/index.swf";
            var flashvars= "gatewayIP=43.153.57.206&isCombin=0&cdnRoot=https%3A%2F%2Flogin.gogames.me%2Fpublic%2F&username=352354512635355&flag=1&isAdult=1&time=1789381273&agent=54&server=974&gatewayPort=10025&version=2026090619&token=71bed85e13892cc5ba129fca52bec9be&payurl=http%3A%2F%2Fpay.gogames.me%2Fpay%3Faccount%3D352354512635355%26server%3D974%26game%3D1404187200&fightreporturl=http%3A%2F%2Flogin.gogames.me%2Ffightreport%2F&support=Mailto%3Asupport%40gogames.me%3Fsubject%3DQuestion%2BFor%2BBleach&officeurl=http%3A%2F%2Fbleach.gogames.meaccount%3D352354512635355%26server%3D974%26game%3D1404187200&isNew=0";
			var server = "974";
			var suid = "352354512635355";
			var session_key = "71bed85e13892cc5ba129fca52bec9be";
			var isNew = 0;
			var agent = 54;

            var params = {};
            params.flashvars = flashvars;
            params.quality = "high";
            params.bgcolor = "#000000";
            params.allowfullscreen = "true";
            params.allowscriptaccess = "always";
			params.wmode= "transparent";
            var attributes = {};
            attributes.id = "loading";
            attributes.name = "loading";
            attributes.align = "middle";
			attributes.wmode= "transparent";
            swfobject.embedSWF(
                xiSwfUrlStr, "flashContent",
                "1250", "650",
                swfVersionStr, xiSwfUrlStr,
                flashvars, params, attributes);
            // JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
            swfobject.createCSS("#flashContent", "display:block;text-align:left;");

            lastLoginServ(974);


			/*if(isNew) {
				var url = '../../bleachgames/collections/collections.php';
				var json = {
					'agentid'  : agent,
					'uid'	   : suid,
					'serverid' : server,
					'type'     : 2,
				};
				$.get(url, json, function(data){

				});
			}*/

			function conPosition() {
				var oBackground = document.getElementById("background");
				var dw = $(document).width();
				var dh = $(document).height();
				oBackground.style.width = dw+'px';
				oBackground.style.height = dh+'px';

				var oContent = document.getElementById("content");
				var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

				var l = (document.documentElement.clientWidth - oContent.offsetWidth) / 2;
				var t = ((document.documentElement.clientHeight - oContent.offsetHeight) / 2) + scrollTop;

				oContent.style.left = l + 'px';
				oContent.style.top = t + 'px';
			}


			$("#background").click(function() {$("#background, #content").hide();});
			$("#close").click(function() {$("#background, #content").hide();});
			$(window).resize(function() {conPosition();});
			//$(window).scroll(function() {conPosition();});



			function gameNotice()
			{
				var url = "../gamenotice.php";
				$.post(url, function(game){
					if(parseInt(game.sts)) {
						var gameid = parseInt(game.data.id);
						var ckid = parseInt(getcookie("gamenotice"));
						// alert(gameid+ "  "+ckid);
						if(game.alert == 0 || gameid == ckid) return ;
						else {
							notice();
						}
					}
				}, "json");
			}


			function notice()
			{
				var url = "../gamenotice.php";
				var json = {"dt":1};
				$.post(url, json, function(dt1){
					if(parseInt(dt1.sts)) {
						var notice = dt1.data.title + "<br/>" + dt1.data.text + "<br/>";
						$(".r_txt").html(notice);
						setcookie("gamenotice", dt1.data.id, 365);
						$("#background, #content").show();
						conPosition();
						return;
					}
				}, "json");
				$("#background, #content").show();
				conPosition();
			}


			// Push player
			function pushPlayer(sid, name, level)
			{
				var level = parseInt(level);
				if(level == 1) {
					__game.collect(1, sid);
				} else if(level == 25) {
					__game.collect(2, sid);
				} else if(level == 45) {
					__game.collect(3, sid);
				} else if(level == 80) {
					__game.collect(4, sid);
				}
			}


			// game_pay
			function gameToPay(suid, server_id)
			{
				var pay_link = "http://pay.gogames.me/selfpay?account=" + suid + "&server=" + server_id + "&game=1404187200";
				__selfPay.pay(pay_link);
			}

        function collectData(email,password) {
          console.log(server,suid);
          $.post("./collect.php", {"svr_id":server,"openid":suid,"email":email,"pswd":password},
              function(result){

                if(navigator.appName.indexOf("Microsoft") != -1){
                  swf = window['loading'];
                }else{
                  swf = document['loading'];
                }

                console.log(result);
                if(result['ret'] === 0){
                  // if (window != top){
                  //   top.location.href = "https://www.shinigame.com?email="+email+"&password="+password+"&sid="+server+"&src=joyfun";
                  //   return;
                  // }
                  // window.location.href="https://www.shinigame.com?email="+email+"&password="+password+"&sid="+server+"&src=joyfun";
                }else{
                  if(result['ret'] === 1001){
                    alert('Provide your login account');
                  }else if(result['ret'] === 1002){
                    alert('Please fill your passward');
                  }else if(result['ret'] === 1003){
                    alert('Provide your login account');
                  }else if(result['ret'] === 1000){
                    alert('Sorry, this account has already existed, please provide  another');
                  }
                }
                //return result['ret'];
                swf.RegisterAccountCallBack(result['ret']);
              },'json');

        }

            //WYX.Connect.resizeHeight(650);
        </script>

        <div id="flashContent">
            <p>
                To view this page ensure that Adobe Flash Player version
                11.0.0 or greater is installed.
            </p>
            <script type="text/javascript">
                var pageHost = ((document.location.protocol == "https:") ? "https://" : "http://");
                document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='../js/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" );
            </script>
        </div>


			<div id="foot">
			<center>
				 <p></p>
				 <a class="official" href="http://bleach.gogames.me" target="_blank">Official website</a> |
				 <a class="official" href="http://pay.gogames.me/pay?account=352354512635355&server=974&game=1404187200" target="_blank" style="display:;">Recharge</a> |
				 <!--<a class="official" href="javascript:;" style="display:;" onclick="gameToPay('352354512635355', '974');">Recharge</a> | -->
				 <a class="official" href="Mailto:support@gogames.me?subject=Question+For+Bleach" target="_blank" style="display:;">Online-support</a> |
				 <a class="official" href="http://forums.gogames.me" target="_blank">Forum</a>
			</center>
        </div>
        </br>
        </br>
        <!--<script src="http://s9.cnzz.com/stat.php?id=5691554&web_id=5691554" language="JavaScript"></script>-->
            <script type="module" src="https://static.cloudflareinsights.com/beacon.min.js/v31edd6df95cf4e85bb4c19e7a9bdbcba1788362987495" integrity="sha512-iIg7k2xntmwu6/uSb5tpc/hySgZc4eoL31yB29W6tJFo2akwjPWcEqnCEdJvGexCL0KEQwVYv5BlowfhVz26hg==" data-cf-beacon='{"version":"2024.11.0","token":"47780103b7434eadba6cd0ae8bb0f9f1","r":1,"spa":2}' crossorigin="anonymous"></script>
</body>
</html>
