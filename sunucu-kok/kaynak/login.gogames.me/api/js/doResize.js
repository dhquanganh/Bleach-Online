var resizeTimer = null;  
var screenWidth = null;
var screenHeight = null;
function doResize()
{
    var screenWidth = document.body.offsetWidth;
    var screenHeight = document.body.offsetHeight;
    if(screenWidth>1250){
        screenWidth = 1250;
    }
	if(screenWidth<=1100){
        screenWidth = 1100;
    }
	
    document.getElementById('loading').width = screenWidth;
    if(screenHeight>650){
        screenHeight = 650;
    }
	if(screenHeight<600){
        screenHeight = 600;
    }
    document.getElementById('loading').height = screenHeight;
    resizeTimer=null ;
}   
window.onresize = function()
{   
    if(resizeTimer==null)
    {
        resizeTimer =
        setTimeout("doResize()",30);   
    }
}

function reloadgame()
{

	location.reload() ;

}


/*
*	统计新手引导步骤发送
*	该函数已被屏蔽
*	原名 analyUser
**/
function analyUser_bak(agentid, step, newUser, uid, serverid)
{
	var url = '../../bleachgames/collections/collections.php';
	var json = {
		'agentid': agentid,
		'step'	 : step,
		'newUser': newUser,
		'uid'	 : uid,
		'serverid' : serverid,
	};
	$.post(url, json, function(data){
		
	},'json');
}
	
/*
*	微游戏接口 - 玩家创号回调
**/
function createRole(name)
{
	var url = './role_update.php';
	var json = {
		'session_key':sign,
		'server_id':server,
		'role_name':name,
		'uid':suid
	};
	$.post(url, json, function(data){
		
	},'json');
}

/* 
*	flash断线日志
 */
function flash_log(log)
{
	var url = '../../bleachgames/collections/flash.php';
	var json = {
		'log':log,
	};
	$.post(url, json, function(data){},'json');
}


	
