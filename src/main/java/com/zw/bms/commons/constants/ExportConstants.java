package com.zw.bms.commons.constants;

import java.util.LinkedHashMap;
import java.util.Map;

public class ExportConstants {
	/**
	 * 导出数据最大条数
	 */
	public static final int EXPORT_MAX_SIZE = 50000;
	
	/**
	 * 默认以id字段排序
	 */
	public static final String EXPORT_ORDER_FIELD_ID = "id";
	
	/**
	 * 降序
	 */
	public static final String EXPORT_ORDER_DESC = "desc";
	
	/**
	 * 升序
	 */
	public static final String EXPORT_ORDER_ASC = "asc";
	
	/**
	 * 车辆信息导出标题
	 */
	public static final String EXPOER_CARINFO_TITLE = "车辆信息导出";
	
	/**
	 * 车辆信息导出表头
	 */
	public final static Map<String,String> EXPORT_CARINFO_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("carNo", "车牌号");
	    	put("isYearCard", "是否年卡");
	    	put("customerName", "客户名称");
	    	put("carStatus", "车辆状态");
	    	put("inUserName", "入库人员");
	    	put("inTime", "入库日期");
	    	put("outUserName", "出库人员");
	    	put("outTime", "出库日期");
		}
	};
	
	
	/**
	 * 客户账户信息汇总导出标题
	 */
	public static final String EXPOER_CUSTACCOUNT_TITLE = "客户账户信息汇总";
	
	/**
	 * 客户账户信息明细导出标题
	 */
	public static final String EXPOER_CUSTACCOUNTDETAIL_TITLE = "客户账户信息明细";
	
	/**
	 * 客户账户信息汇总导出表头
	 */
	public final static Map<String,String> EXPORT_CUSTACCOUNT_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("custName", "客户名称");
			put("total", "总额");
			put("nonpay", "未付款");
			put("payed", "已收款");
			put("subtotal", "账户结余");
		}
	};
	
	/**
	 * 客户账户信息明细导出表头
	 */
	public final static Map<String,String> EXPORT_CUSTACCOUNTDETAIL_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("custName", "客户名称");
			put("amount", "金额");
			put("record_time", "记账日期");
			put("paymentMode", "付款方式");
			put("createUserName", "操作人");
			put("remark", "备注");
		}
	};
	
	/**
	 * 森桥日报表导出标题
	 */
	public static final String EXPOER_DAILYREPORT4SQ_TITLE = "森桥物流中心仓储收费汇日报表";
	
	/**
	 * 森桥日报表导出表头
	 */
	public final static Map<String,String> EXPORT_DAILYREPORT4SQ_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("dailyDate", "记账日期");
			put("carNo", "车号");
			put("outStockNo", "出车单号");
			put("goodsStoreNo", "货位号");
			put("custName", "客户名称");
			put("chargeTypeName", "业务类型");
			put("goodsName", "货物名称");
			put("parkDays", "停车天数");
			put("stockDays", "堆存天数");
			put("netWeight", "重量(KG)");
			put("wsfAmount", "卫生费(制卡费)");
			put("glfAmount", "管理费(过磅费)");
			put("tcfAmount", "停车费小计");
			put("tcfAmount_yj", "停车费月结");
			put("tcfAmount_ss", "停车费实时");
			put("dhfAmount", "倒货费");
			put("ydfAmount", "运抵费");
			put("zxfAmount", "装卸费");
			put("ccfAmount", "仓储费小计");
			put("ccfAmount_yj", "仓储费月结");
			put("ccfAmount_ss", "仓储费实时");
			put("zgfAmount", "转关费小计");
			put("zgfAmount_yj", "转关费月结");
			put("zgfAmount_ss", "转关费实时");
			put("khyhfAmount", "客户优惠");
			put("qtfAmount", "其他费用");
			put("sumAmount", "应收费小计");
			put("payedAmount", "实时收费小计");
			put("cashAmount", "现金收费小计");
			put("nonPayAmount", "月结欠款小计");
			put("paymentMode", "收费类型");
			put("userName", "收费员");
			put("outRemark", "出库说明");
		}
	};
	
	/**
	 * 福地日报表导出标题
	 */
	public static final String EXPOER_DAILYREPORT4FD_TITLE = "伊犁福地农业海关监管库收费汇日报表";
	
	/**
	 * 森桥日报表导出表头
	 */
	public final static Map<String,String> EXPORT_DAILYREPORT4FD_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("inTime", "进库日期");
			put("inCarNo", "进库车号");
			put("contractNo", "合同号");
			put("waybillNo", "运单号");
			put("goodsName", "货物名称");
			put("goodsQuantity", "件数/包");
			put("netWeight", "重量/吨");
			put("goodsStoreNo", "货位号");
			put("outCarNo", "出库车号");
			put("dailyDate", "记账日期");
			put("custName", "公司名称");
			put("ccfAmount", "仓储费");
			put("khyhfAmount", "客户优惠");
			put("qtfAmount", "其他费用");
			put("sumAmount", "应收费小计");
			put("payedAmount", "实时收费小计");
			put("cashAmount", "现金收费小计");
			put("nonPayAmount", "月结欠款小计");
			put("paymentMode", "收费类型");
			put("userName", "收费员");
		}
	};
	
	/**
	 * 森桥月报表导出标题
	 */
	public static final String EXPOER_MONTHLYREPORT4SQ_TITLE = "仓储收费汇月报表";
	
	/**
	 * 森桥月报表导出表头
	 */
	public final static Map<String,String> EXPORT_MONTHLYREPORT4SQ_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("dailyDate", "记账日期");
			put("wsfAmount", "卫生费(制卡费)");
			put("glfAmount", "管理费(过磅费)");
			put("tcfAmount", "停车费");
			put("dhfAmount", "倒货费");
			put("ydfAmount", "运抵费");
			put("zxfAmount", "装卸费");
			put("ccfAmount", "仓储费");
			put("zgfAmount", "转关费");
			put("khyhfAmount", "客户优惠");
			put("qtfAmount", "其他费用");
			put("sumAmount", "应收费合计");
			put("sqAmount", "森桥收费合计");
			put("fdAmount", "福地收费合计");
			put("payedAmount", "实时收费合计");
			put("cashAmount", "现金收费小计");
			put("nonPayAmount", "月结欠款合计");
		}
	};
	
	/**
	 * 森桥年报表导出标题
	 */
	public static final String EXPOER_YEARREPORT4SQ_TITLE = "仓储收费汇年报表";
	
	/**
	 * 森桥年报表导出表头
	 */
	public final static Map<String,String> EXPORT_YEARREPORT4SQ_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("dailyDate", "记账日期");
			put("wsfAmount", "卫生费(制卡费)");
			put("glfAmount", "管理费(过磅费)");
			put("tcfAmount", "停车费");
			put("dhfAmount", "倒货费");
			put("ydfAmount", "运抵费");
			put("zxfAmount", "装卸费");
			put("ccfAmount", "仓储费");
			put("zgfAmount", "转关费");
			put("khyhfAmount", "客户优惠");
			put("qtfAmount", "其他费用");
			put("sumAmount", "应收费合计");
			put("sqAmount", "森桥收费合计");
			put("fdAmount", "福地收费合计");
			put("payedAmount", "实时收费合计");
			put("cashAmount", "现金收费小计");
			put("nonPayAmount", "月结欠款合计");
		}
	};
	
	/**
	 * 客户月结回款进度报表导出标题
	 */
	public static final String EXPOER_CUSTRETURNMONEY_TITLE = "客户月结回款进度表";
	
	/**
	 * 森桥年报表导出表头
	 */
	public final static Map<String,String> EXPORT_CUSTRETURNMONEY_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("customerName", "客户名称");
			put("lastDate", "回款截止日期");
			put("nonPayAmount", "月结金额");
			put("backAmount", "已回款金额");
			put("balanceAmount", "欠款金额");
			put("overAmount", "超期回款金额");
			
		}
	};
	
	/**
	 * 货物出入库报表导出标题
	 */
	public static final String EXPOER_DAILYSTOREDETAILLIST_TITLE = "货物出入库报表";
	
	/**
	 * 货物出入库报表导出表头
	 */
	public final static Map<String,String> EXPORT_DAILYSTOREDETAILLIST_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("carNo", "车牌号");
			put("cardNo", "运通卡号");
			put("custName", "客户名称");
			put("inTime", "车辆入库日期");
			put("outTime", "车辆出库日期");
			put("storeName", "库房名称");
			put("type", "业务类型");
			put("busiDate", "业务日期");
			put("sumNet", "货物净重(吨)");
			put("sumAmount", "货物数量");
			put("goodsName", "货物名称");
			put("userName", "操作人员");
		}
	};
	
	/**
	 * 库房出入库统计报表导出标题
	 */
	public static final String EXPOER_DAILYCUSTOMERSTORELIST_TITLE = "库房出入库报表";
	
	/**
	 * 库房出入库统计报表导出表头
	 */
	public final static Map<String,String> EXPORT_DAILYCUSTOMERSTORELIST_HEAD = new LinkedHashMap<String,String>(){
		
		private static final long serialVersionUID = 1L;
		
		{
			put("storeName", "库房名称");
			put("custName", "客户名称");
			put("inCount", "入库车数");
			put("goodsInNet", "入库货物净重(吨)");
			put("goodsInAmount", "入库货物数量");
			put("inGoodsName", "入库货物名称");
			put("outCount", "出库车数");
			put("goodsOutNet", "出库货物净重(吨)");
			put("goodsOutAmount", "出库货物数量");
			put("outGoodsName", "出库货物名称");
		}
	};
}
