/**
 * 初始化ID读卡器串口
 * @param tcom
 */
function tcommInit(){
	var tcomInit = new TComm("COM4","9600,N,8,1");
	var objCom={
			COMOBJ:tcomInit,
			init:function(tcomInit){
					tcomInit.Register("ab441c4f6540cbffb6528b7a52fde693caa15ac1b33595b43b97fc7ec43f232790a650a3817f7b2541971ba70bd8df61ebd5242e8c07fa00d644179918c219037efe85df300381d5", function (dat) {
						if (dat==-99 || dat.STAT == -99) {
								if (confirm("您还没有安装串口插件\n\n现在下载安装吗？")) {
										location = "http://d.iyanhong.com/files/TComm2.exe";
								}
							} else if (dat.STAT == 11) {
								tcomInit.init(function (ret) {
									if (ret.STAT == 1) {
										// 初始化成功 打开串口成功
									} else {
										alert("打开串口失败,请联系系统管理员!");
									}
								});
							} else {
								alert("注册失败,请与您的服务商联系!");
							}
					});
			},
			close : function(){
				tcomInit.Close(function(){
					//alert("已关闭");
				});
			}
		};
	// objCom.init(tcomInit);
	return objCom;
}

/**
 * 关闭读卡器串口
 * @param tcom
 */
function tcommClose(){
	tcom.close();
}

var tcom = tcommInit();//全局变量 - 初始化读卡器串口 