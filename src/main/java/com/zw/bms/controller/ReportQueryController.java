package com.zw.bms.controller;

import java.io.UnsupportedEncodingException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.constants.ExportConstants;
import com.zw.bms.commons.report.excel.ExcelUtil;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.model.CarInfo;
import com.zw.bms.service.IReportQueryService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
@Controller
@RequestMapping("/reportQuery")
public class ReportQueryController extends BaseController {

    @Autowired 
    private IReportQueryService reportQueryService;
    
    @RequestMapping(value="/carInfoReport")
    public String carInfoReport(){
    	return "bi/reportQuery/carInfoReportQueryList";
    }
    
    /**
     * 列表查询
     * @param carInfo
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param request
     * @return
     */
    @PostMapping("/queryCarInfoReport")
    @ResponseBody
    public PageInfo queryCarInfoReport(CarInfo carInfo,Integer page, Integer rows, String sort,String order,HttpServletRequest request){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", request.getParameter("carNo"));
    	paramMap.put("inTimeStart", request.getParameter("inTimeStart"));
    	paramMap.put("inTimeEnd", DateUtil.getDayAfter(request.getParameter("inTimeEnd")));
    	paramMap.put("outTimeStart", request.getParameter("outTimeStart"));
    	paramMap.put("outTimeEnd", DateUtil.getDayAfter(request.getParameter("outTimeEnd")));
    	paramMap.put("carStatus", request.getParameter("carStatus"));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	pages.setRecords(reportQueryService.queryCarInfoReport(pages,paramMap));
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 列表导出，最大支持5万条数据
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportCarInfoReport")
    @ResponseBody
    public Object exportCarInfoReport(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", request.getParameter("carNo"));
    	paramMap.put("inTimeStart", request.getParameter("inTimeStart"));
    	paramMap.put("inTimeEnd", DateUtil.getDayAfter(request.getParameter("inTimeEnd")));
    	paramMap.put("outTimeStart", request.getParameter("outTimeStart"));
    	paramMap.put("outTimeEnd", DateUtil.getDayAfter(request.getParameter("outTimeEnd")));
    	paramMap.put("carStatus", request.getParameter("carStatus"));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,ExportConstants.EXPORT_ORDER_FIELD_ID, ExportConstants.EXPORT_ORDER_DESC);
    	ja.addAll(reportQueryService.queryCarInfoReport(pages,paramMap));
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_CARINFO_TITLE, ExportConstants.EXPORT_CARINFO_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 账户信息汇总页面
     * @return
     */
    @RequestMapping(value="/custAccountReport")
    public String custAccountReport(){
    	return "bi/reportQuery/custAccountReportQueryList";
    }
    
    /**
     * 账户信息汇总查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     * @throws UnsupportedEncodingException 
     */
    @PostMapping("/queryCustAccountReport")
    @ResponseBody
    public PageInfo queryCustAccountReport(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("recordTimeStart", request.getParameter("recordTimeStart"));
    	paramMap.put("recordTimeEnd", DateUtil.getDayAfter(request.getParameter("recordTimeEnd")));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryCustAccountReport(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooter4CustAccountReport(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 账户信息汇总查询导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportCustAccountReport")
    @ResponseBody
    public Object exportCustAccountReport(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("recordTimeStart", request.getParameter("recordTimeStart"));
    	paramMap.put("recordTimeEnd", DateUtil.getDayAfter(request.getParameter("recordTimeEnd")));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,"customer_id", ExportConstants.EXPORT_ORDER_ASC);
    	List<HashMap<String,Object>> records = reportQueryService.queryCustAccountReport(pages,paramMap);
    	ja.addAll(records);
    	ja.addAll(this.appendFooter4CustAccountReport(records));
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_CUSTACCOUNT_TITLE, ExportConstants.EXPORT_CUSTACCOUNT_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 账户信息明细页面
     * @return
     * @throws UnsupportedEncodingException 
     */
    @RequestMapping(value="/custAccountDetailReport")
    public String custAccountDetailReport(Model model,HttpServletRequest request) throws UnsupportedEncodingException{
    	model.addAttribute("custId", request.getParameter("custId"));
    	model.addAttribute("custName", new String(request.getParameter("custName").getBytes("ISO-8859-1"), "UTF-8"));
    	model.addAttribute("recordTimeStart", request.getParameter("recordTimeStart"));
    	model.addAttribute("recordTimeEnd", DateUtil.getDayAfter(request.getParameter("recordTimeEnd")));
    	return "bi/reportQuery/custAccountDetailReportQueryList";
    }
    
    /**
     * 账户信息明细查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     * @throws UnsupportedEncodingException 
     */
    @PostMapping("/queryCustAccountDetailReport")
    @ResponseBody
    public PageInfo queryCustAccountDetailReport(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custId", request.getParameter("custId"));
//    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("recordTimeStart", request.getParameter("recordTimeStart"));
    	paramMap.put("recordTimeEnd", DateUtil.getDayAfter(request.getParameter("recordTimeEnd")));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryCustAccountDetailReport(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    @RequestMapping(value="/exportCustAccountDetailReport")
    @ResponseBody
    public Object exportCustAccountDetailReport(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custId", request.getParameter("custId"));
    	paramMap.put("recordTimeStart", request.getParameter("recordTimeStart"));
    	paramMap.put("recordTimeEnd", DateUtil.getDayAfter(request.getParameter("recordTimeEnd")));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,"id", ExportConstants.EXPORT_ORDER_DESC);
    	List<HashMap<String,Object>> records = reportQueryService.queryCustAccountDetailReport(pages,paramMap);
    	ja.addAll(records);
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_CUSTACCOUNTDETAIL_TITLE, ExportConstants.EXPORT_CUSTACCOUNTDETAIL_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 森桥日报表页面
     * @return
     */
    @RequestMapping(value="/dailyReport4Sq")
    public String dailyReport4SqPage(Model model){
    	model.addAttribute("dailyDateStart",DateUtil.getNowDateString());
    	model.addAttribute("dailyDateEnd",DateUtil.getNowDateString());
    	return "bi/reportQuery/queryDailyReport4SqList";
    }
    
    /**
     * 森桥日报表查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/queryDailyReport4SqList")
    @ResponseBody
    public PageInfo queryDailyReport4SqList(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("carNo", StringUtils.isNotBlank(request.getParameter("carNo")) ? request.getParameter("carNo").toUpperCase() : "" );
    	paramMap.put("dailyDateStart", StringUtils.isNotBlank(request.getParameter("dailyDateStart")) ? request.getParameter("dailyDateStart") : DateUtil.getNowDateString());
    	paramMap.put("dailyDateEnd", StringUtils.isNotBlank(request.getParameter("dailyDateEnd")) ? DateUtil.getDayAfter(request.getParameter("dailyDateEnd")) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4SqList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    
    /**
     * 森桥日报表导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportDailyReport4Sq")
    @ResponseBody
    public Object exportDailyReport4SqList(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("carNo", StringUtils.isNotBlank(request.getParameter("carNo")) ? request.getParameter("carNo").toUpperCase() : "" );
    	paramMap.put("dailyDateStart", request.getParameter("dailyDateStart"));
    	paramMap.put("dailyDateEnd", DateUtil.getDayAfter(request.getParameter("dailyDateEnd")));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,null,null);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4SqList(pages,paramMap);
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_DAILYREPORT4SQ_TITLE, ExportConstants.EXPORT_DAILYREPORT4SQ_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 森桥月报表页面
     * @return
     */
    @RequestMapping(value="/monthlyReport4Sq")
    public String monthlyReport4SqPage(Model model){
    	model.addAttribute("dailyDateStart",DateUtil.getNowMonthString());
    	model.addAttribute("dailyDateEnd",DateUtil.getNowMonthString());
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	return "bi/reportQuery/queryMonthlyReport4SqList";
    }
    
    /**
     * 森桥月报表查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/queryMonthlyReport4SqList")
    @ResponseBody
    public PageInfo queryMonthlyReport4SqList(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("location", StringUtils.isNotBlank(request.getParameter("location")) ? request.getParameter("location") : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dailyDateStart", StringUtils.isNotBlank(request.getParameter("dailyDateStart")) ? request.getParameter("dailyDateStart") : DateUtil.getNowMonthString());
    	paramMap.put("dailyDateEnd", StringUtils.isNotBlank(request.getParameter("dailyDateEnd")) ? DateUtil.getNextMonth2DefaultFormat(request.getParameter("dailyDateEnd")) : DateUtil.getNextMonth2DefaultFormat(DateUtil.getNowMonthString()));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryMonthlyReport4SqList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 森桥月报表导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportMonthlyReport4Sq")
    @ResponseBody
    public Object exportMonthlyReport4SqList(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("location", request.getParameter("location"));
    	paramMap.put("dailyDateStart", request.getParameter("dailyDateStart"));
    	paramMap.put("dailyDateEnd", DateUtil.getNextMonth2DefaultFormat(request.getParameter("dailyDateEnd")));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,"out_time", ExportConstants.EXPORT_ORDER_ASC);
    	List<HashMap<String,Object>> records = reportQueryService.queryMonthlyReport4SqList(pages,paramMap);
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_MONTHLYREPORT4SQ_TITLE, ExportConstants.EXPORT_MONTHLYREPORT4SQ_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 森桥年报表页面
     * @return
     */
    @RequestMapping(value="/yearReport4Sq")
    public String yearReport4SqPage(Model model){
    	model.addAttribute("dailyDateStart",DateUtil.getNowYear());
    	model.addAttribute("dailyDateEnd",DateUtil.getNowYear());
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	return "bi/reportQuery/queryYearReport4SqList";
    }
    
    /**
     * 森桥年报表查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/queryYearReport4SqList")
    @ResponseBody
    public PageInfo queryYearReport4SqList(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("location", StringUtils.isNotBlank(request.getParameter("location")) ? request.getParameter("location") : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dailyDateStart", StringUtils.isNotBlank(request.getParameter("dailyDateStart")) ? request.getParameter("dailyDateStart") : DateUtil.getNowYear());
    	paramMap.put("dailyDateEnd", StringUtils.isNotBlank(request.getParameter("dailyDateEnd")) ? request.getParameter("dailyDateEnd") : DateUtil.getNowYear());
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryYearReport4SqList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 森桥年报表导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportYearReport4Sq")
    @ResponseBody
    public Object exportYearReport4SqList(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("location", request.getParameter("location"));
    	paramMap.put("dailyDateStart", request.getParameter("dailyDateStart"));
    	paramMap.put("dailyDateEnd", request.getParameter("dailyDateEnd"));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,"out_time", ExportConstants.EXPORT_ORDER_ASC);
    	List<HashMap<String,Object>> records = reportQueryService.queryYearReport4SqList(pages,paramMap);
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4Sq(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_YEARREPORT4SQ_TITLE, ExportConstants.EXPORT_YEARREPORT4SQ_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 福地日报表页面
     * @return
     */
    @RequestMapping(value="/dailyReport4Fd")
    public String dailyReport4FdPage(Model model){
    	model.addAttribute("dailyDateStart",DateUtil.getNowDateString());
    	model.addAttribute("dailyDateEnd",DateUtil.getNowDateString());
    	return "bi/reportQuery/queryDailyReport4FdList";
    }
    
    /**
     * 森桥日报表查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @PostMapping("/queryDailyReport4FdList")
    @ResponseBody
    public PageInfo queryDailyReport4FdList(HttpServletRequest request,Integer page, Integer rows, String sort,String order){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("dailyDateStart", StringUtils.isNotBlank(request.getParameter("dailyDateStart")) ? request.getParameter("dailyDateStart") : DateUtil.getNowDateString());
    	paramMap.put("dailyDateEnd", StringUtils.isNotBlank(request.getParameter("dailyDateEnd")) ? DateUtil.getDayAfter(request.getParameter("dailyDateEnd")) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4FdList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4Fd(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    
    /**
     * 福地日报表导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value="/exportDailyReport4Fd")
    @ResponseBody
    public Object exportDailyReport4FdList(HttpServletRequest request,HttpServletResponse response){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("custName", request.getParameter("custName"));
    	paramMap.put("dailyDateStart", request.getParameter("dailyDateStart"));
    	paramMap.put("dailyDateEnd", DateUtil.getDayAfter(request.getParameter("dailyDateEnd")));
    	JSONArray ja = new JSONArray();
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,"out_time", ExportConstants.EXPORT_ORDER_ASC);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4FdList(pages,paramMap);
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4Fd(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_DAILYREPORT4FD_TITLE, ExportConstants.EXPORT_DAILYREPORT4FD_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 客户回款进度表页面
     * @return
     */
    @RequestMapping(value="/customerReturnMoney")
    public String customerReturnMoneyPage(Model model){
    	model.addAttribute("paymentMonth",DateUtil.getNowMonthString());
    	return "bi/reportQuery/queryCustomerReturnMoneyReport";
    }
    
    /**
     * 客户月结回款进度查询
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param custName
     * @param paymentMonth
     * @return
     */
    @PostMapping("/queryCustomerReturnMoneyList")
    @ResponseBody
    public PageInfo queryCustomerReturnMoneyList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "paymentMonth",required=false) String paymentMonth){
    	if(StringUtils.isEmpty(paymentMonth)){
    		paymentMonth = DateUtil.getNowMonthString();
    	}
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = Collections.emptyList();
    	if(StringUtils.isNotBlank(paymentMonth)){
    		HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
        	paramMap.put("custName", custName);
        	paramMap.put("paymentMonth", paymentMonth);
        	paramMap.put("dateStart", DateUtil.getDateFormat(DateUtil.getFirstDayOfMonth(DateUtil.formatDate(paymentMonth, DateUtil.MONTH_DEFAULT_FORMAT))));
        	paramMap.put("dateEnd", DateUtil.getDateFormat(DateUtil.getLastDayOfMonth(DateUtil.formatDate(paymentMonth, DateUtil.MONTH_DEFAULT_FORMAT))));
        	paramMap.put("lastDate", DateUtil.getNextMonth2DefaultFormat(paymentMonth) + "-10"); //截止日期为次月10日
        	records = reportQueryService.queryCustomerReturnMoneyList(pages,paramMap);
    	}
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterCustomerReturnMoney(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 客户月结回款进度导出
     * @param response
     * @param custName
     * @param paymentMonth
     * @return
     */
    @RequestMapping("/exportCustomerReturnMoney")
    @ResponseBody
    public Object exportCustomerReturnMoney(HttpServletResponse response,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "paymentMonth",required=false) String paymentMonth){
    	if(StringUtils.isEmpty(paymentMonth)){
    		paymentMonth = DateUtil.getNowMonthString();
    	}
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,null, null);
    	List<HashMap<String,Object>> records = Collections.emptyList();
    	if(StringUtils.isNotBlank(paymentMonth)){
    		HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
        	paramMap.put("custName", custName);
        	paramMap.put("paymentMonth", paymentMonth);
        	paramMap.put("dateStart", DateUtil.getFirstDayOfMonth(DateUtil.formatDate(paymentMonth, DateUtil.MONTH_DEFAULT_FORMAT)));
        	paramMap.put("dateEnd", DateUtil.getLastDayOfMonth(DateUtil.formatDate(paymentMonth, DateUtil.MONTH_DEFAULT_FORMAT)));
        	paramMap.put("lastDate", DateUtil.getNextMonth2DefaultFormat(paymentMonth));
    		records = reportQueryService.queryCustomerReturnMoneyList(pages,paramMap);
    	}
    	JSONArray ja = new JSONArray();
    	ja.addAll(records);
    	ja.addAll(this.appendFooterCustomerReturnMoney(records));
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_CUSTRETURNMONEY_TITLE, ExportConstants.EXPORT_CUSTRETURNMONEY_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 货物出入库报表页面
     * @return
     */
    @RequestMapping(value="/dailyReport4StoreDetailList")
    public String dailyReport4StoreDetailListPage(Model model){
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	model.addAttribute("busiDateStart", DateUtil.getNowDateString());
    	model.addAttribute("busiDateEnd", DateUtil.getNowDateString());
    	return "bi/reportQuery/queryDailyReport4StoreDetailList";
    }
    
    /**
     * 货物出入库报表查询
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param location
     * @param custName
     * @param type
     * @param storeId
     * @param inTimeStart
     * @param inTimeEnd
     * @param outTimeStart
     * @param outTimeEnd
     * @param busiDateStart
     * @param busiDateEnd
     * @return
     */
    @RequestMapping(value="/queryDailyReport4StoreDetailList")
    @ResponseBody
    public PageInfo queryDailyReport4StoreDetailList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "cardNo",required=false) String cardNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "type",required=false) String type,
    		@RequestParam(value = "storeId",required=false) Long storeId,
    		@RequestParam(value = "inTimeStart",required=false) String inTimeStart,
    		@RequestParam(value = "inTimeEnd",required=false) String inTimeEnd,
    		@RequestParam(value = "outTimeStart",required=false) String outTimeStart,
    		@RequestParam(value = "outTimeEnd",required=false) String outTimeEnd,
    		@RequestParam(value = "busiDateStart",required=false) String busiDateStart,
    		@RequestParam(value = "busiDateEnd",required=false) String busiDateEnd){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("cardNo", cardNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("custName", custName);
    	paramMap.put("type", type);
    	paramMap.put("storeId", storeId);
    	paramMap.put("inTimeStart", inTimeStart);
    	paramMap.put("inTimeEnd", StringUtils.isNotBlank(inTimeEnd) ? DateUtil.getDayAfter(inTimeEnd) : null);
    	paramMap.put("outTimeStart", outTimeStart);
    	paramMap.put("outTimeEnd", StringUtils.isNotBlank(outTimeEnd) ? DateUtil.getDayAfter(outTimeEnd) : null);
    	paramMap.put("busiDateStart", StringUtils.isNotBlank(busiDateStart) ? busiDateStart : DateUtil.getNowDateString());
    	paramMap.put("busiDateEnd", StringUtils.isNotBlank(busiDateEnd) ? DateUtil.getDayAfter(busiDateEnd) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4StoreDetailList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4StoreDetailList(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 货物出入库报表导出
     * @param response
     * @param carNo
     * @param location
     * @param custName
     * @param type
     * @param storeId
     * @param inTimeStart
     * @param inTimeEnd
     * @param outTimeStart
     * @param outTimeEnd
     * @param busiDateStart
     * @param busiDateEnd
     * @return
     */
    @RequestMapping("/exportDailyReport4StoreDetailList")
    @ResponseBody
    public Object exportDailyReport4StoreDetailList(HttpServletResponse response,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "cardNo",required=false) String cardNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "type",required=false) String type,
    		@RequestParam(value = "storeId",required=false) Long storeId,
    		@RequestParam(value = "inTimeStart",required=false) String inTimeStart,
    		@RequestParam(value = "inTimeEnd",required=false) String inTimeEnd,
    		@RequestParam(value = "outTimeStart",required=false) String outTimeStart,
    		@RequestParam(value = "outTimeEnd",required=false) String outTimeEnd,
    		@RequestParam(value = "busiDateStart",required=false) String busiDateStart,
    		@RequestParam(value = "busiDateEnd",required=false) String busiDateEnd){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("cardNo", cardNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("custName", custName);
    	paramMap.put("type", type);
    	paramMap.put("storeId", storeId);
    	paramMap.put("inTimeStart", inTimeStart);
    	paramMap.put("inTimeEnd", StringUtils.isNotBlank(inTimeEnd) ? DateUtil.getDayAfter(inTimeEnd) : null);
    	paramMap.put("outTimeStart", outTimeStart);
    	paramMap.put("outTimeEnd", StringUtils.isNotBlank(outTimeEnd) ? DateUtil.getDayAfter(outTimeEnd) : null);
    	paramMap.put("busiDateStart", StringUtils.isNotBlank(busiDateStart) ? busiDateStart : DateUtil.getNowDateString());
    	paramMap.put("busiDateEnd", StringUtils.isNotBlank(busiDateEnd) ? DateUtil.getDayAfter(busiDateEnd) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,null, null);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4StoreDetailList(pages,paramMap);
    	JSONArray ja = new JSONArray();
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4StoreDetailList(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_DAILYSTOREDETAILLIST_TITLE, ExportConstants.EXPORT_DAILYSTOREDETAILLIST_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 以客户和库房维度查询货物出入库报表页面
     * @return
     */
    @RequestMapping(value="/dailyReport4CustomerStoreList")
    public String dailyReport4CustomerStoreListPage(Model model){
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	model.addAttribute("busiDateStart", DateUtil.getNowDateString());
    	model.addAttribute("busiDateEnd", DateUtil.getNowDateString());
    	return "bi/reportQuery/queryDailyReport4CustomerStoreList";
    }
    
    /**
     * 以客户和库房维度查询货物出入库报表查询
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param location
     * @param custName
     * @param type
     * @param storeId
     * @param busiDateStart
     * @param busiDateEnd
     * @return
     */
    @RequestMapping(value="/queryDailyReport4CustomerStoreList")
    @ResponseBody
    public PageInfo queryDailyReport4CustomerStoreList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "type",required=false) String type,
    		@RequestParam(value = "storeId",required=false) Long storeId,
    		@RequestParam(value = "busiDateStart",required=false) String busiDateStart,
    		@RequestParam(value = "busiDateEnd",required=false) String busiDateEnd){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("custName", custName);
    	paramMap.put("type", type);
    	paramMap.put("storeId", storeId);
    	paramMap.put("busiDateStart", StringUtils.isNotBlank(busiDateStart) ? busiDateStart : DateUtil.getNowDateString());
    	paramMap.put("busiDateEnd", StringUtils.isNotBlank(busiDateEnd) ? DateUtil.getDayAfter(busiDateEnd) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4CustomerStoreList(pages,paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterDailyReport4CustomerStoreList(records));//增加datagrid页脚（统计行）
    	return pageInfo;
    }
    
    /**
     * 以客户和库房维度查询货物出入库报表导出
     * @param response
     * @param location
     * @param custName
     * @param type
     * @param storeId
     * @param busiDateStart
     * @param busiDateEnd
     * @return
     */
    @RequestMapping("/exportDailyReport4CustomerStoreList")
    @ResponseBody
    public Object exportDailyReport4CustomerStoreList(HttpServletResponse response,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "custName",required=false) String custName,
    		@RequestParam(value = "type",required=false) String type,
    		@RequestParam(value = "storeId",required=false) Long storeId,
    		@RequestParam(value = "busiDateStart",required=false) String busiDateStart,
    		@RequestParam(value = "busiDateEnd",required=false) String busiDateEnd){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("custName", custName);
    	paramMap.put("type", type);
    	paramMap.put("storeId", storeId);
    	paramMap.put("busiDateStart", StringUtils.isNotBlank(busiDateStart) ? busiDateStart : DateUtil.getNowDateString());
    	paramMap.put("busiDateEnd", StringUtils.isNotBlank(busiDateEnd) ? DateUtil.getDayAfter(busiDateEnd) : DateUtil.getDayAfter(DateUtil.getNowDateString()));
    	Page<HashMap<String,Object>> pages = getPage(1,ExportConstants.EXPORT_MAX_SIZE,null, null);
    	List<HashMap<String,Object>> records = reportQueryService.queryDailyReport4CustomerStoreList(pages,paramMap);
    	JSONArray ja = new JSONArray();
    	ja.addAll(records);
    	ja.addAll(this.appendFooterDailyReport4CustomerStoreList(records));//增加datagrid页脚（统计行）
    	try{
    		ExcelUtil.downloadExcelFile(ExportConstants.EXPOER_DAILYCUSTOMERSTORELIST_TITLE, ExportConstants.EXPORT_DAILYCUSTOMERSTORELIST_HEAD,ja, response);
    	}catch(Exception e){
    		return renderError("导出失败！");
    	}
    	return renderSuccess("导出Excel成功！");
    }
    
    /**
     * 账户信息汇总查询页脚
     * @param pageInfo
     * @param records
     */
    private JSONArray appendFooter4CustAccountReport(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dTotal=0d,dNonpay=0d,dPayed=0d,dSubtotal=0d;
    	for(HashMap<String,Object> record : records){
    		dTotal += Double.valueOf(null != record.get("total") ? String.valueOf(record.get("total")) : "0").doubleValue();
    		dNonpay += Double.valueOf(null != record.get("nonpay") ? String.valueOf(record.get("nonpay")) : "0").doubleValue();
    		dPayed += Double.valueOf(null != record.get("payed") ? String.valueOf(record.get("payed")) : "0").doubleValue();
    		dSubtotal += Double.valueOf(null != record.get("subtotal") ? String.valueOf(record.get("subtotal")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("custName", "统计：");
    	jo.put("total", dTotal);
    	jo.put("nonpay", dNonpay);
    	jo.put("payed", dPayed);
    	jo.put("subtotal", dSubtotal);
    	ja.add(jo);
    	return ja;
    }
    
    /**
     * 森桥日报表统计页脚
     * @param records
     * @return
     */
    private JSONArray appendFooterDailyReport4Sq(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dNetWeight=0d,dSumAmount=0d,dCcfAmount=0d,dWsfAmount=0d,dGlfAmount=0d;
    	double dTcfAmount=0d,dDhfAmount=0d,dYdfAmount=0d,dZxfAmount=0d,dZgfAmount=0d;
    	double dKhyhfAmount=0d,dQtfAmount=0d,dCashAmount=0d,dPayedAmount=0d,dNonPayAmount=0d;
    	double dSqAmount=0d,dFdAmount=0d;
    	double dTcfAmountYj=0d,dTcfAmountSs=0d;//停车费月结/实时
    	double dCcfAmountYj=0d,dCcfAmountSs=0d;//仓储费月结/实时
    	double dZgfAmountYj=0d,dZgfAmountSs=0d;//转关费月结/实时
    	for(HashMap<String,Object> record : records){
    		dNetWeight += Double.valueOf(null != record.get("netWeight") ? String.valueOf(record.get("netWeight")) : "0").doubleValue();
    		dSumAmount += Double.valueOf(null != record.get("sumAmount") ? String.valueOf(record.get("sumAmount")) : "0").doubleValue();
    		dCcfAmount += Double.valueOf(null != record.get("ccfAmount") ? String.valueOf(record.get("ccfAmount")) : "0").doubleValue();
    		dWsfAmount += Double.valueOf(null != record.get("wsfAmount") ? String.valueOf(record.get("wsfAmount")) : "0").doubleValue();
    		dGlfAmount += Double.valueOf(null != record.get("glfAmount") ? String.valueOf(record.get("glfAmount")) : "0").doubleValue();
    		dTcfAmount += Double.valueOf(null != record.get("tcfAmount") ? String.valueOf(record.get("tcfAmount")) : "0").doubleValue();
    		dDhfAmount += Double.valueOf(null != record.get("dhfAmount") ? String.valueOf(record.get("dhfAmount")) : "0").doubleValue();
    		dYdfAmount += Double.valueOf(null != record.get("ydfAmount") ? String.valueOf(record.get("ydfAmount")) : "0").doubleValue();
    		dZxfAmount += Double.valueOf(null != record.get("zxfAmount") ? String.valueOf(record.get("zxfAmount")) : "0").doubleValue();
    		dZgfAmount += Double.valueOf(null != record.get("zgfAmount") ? String.valueOf(record.get("zgfAmount")) : "0").doubleValue();
    		dKhyhfAmount += Double.valueOf(null != record.get("khyhfAmount") ? String.valueOf(record.get("khyhfAmount")) : "0").doubleValue();
    		dQtfAmount += Double.valueOf(null != record.get("qtfAmount") ? String.valueOf(record.get("qtfAmount")) : "0").doubleValue();
    		dCashAmount += Double.valueOf(null != record.get("cashAmount") ? String.valueOf(record.get("cashAmount")) : "0").doubleValue();
    		dPayedAmount += Double.valueOf(null != record.get("payedAmount") ? String.valueOf(record.get("payedAmount")) : "0").doubleValue();
    		dNonPayAmount += Double.valueOf(null != record.get("nonPayAmount") ? String.valueOf(record.get("nonPayAmount")) : "0").doubleValue();
    		dSqAmount += Double.valueOf(null != record.get("sqAmount") ? String.valueOf(record.get("sqAmount")) : "0").doubleValue();
    		dFdAmount += Double.valueOf(null != record.get("fdAmount") ? String.valueOf(record.get("fdAmount")) : "0").doubleValue();
    		dTcfAmountYj += Double.valueOf(null != record.get("tcfAmount_yj") ? String.valueOf(record.get("tcfAmount_yj")) : "0").doubleValue();
    		dCcfAmountYj += Double.valueOf(null != record.get("ccfAmount_yj") ? String.valueOf(record.get("ccfAmount_yj")) : "0").doubleValue();
    		dZgfAmountYj += Double.valueOf(null != record.get("zgfAmount_yj") ? String.valueOf(record.get("zgfAmount_yj")) : "0").doubleValue();
    		dTcfAmountSs += Double.valueOf(null != record.get("tcfAmount_ss") ? String.valueOf(record.get("tcfAmount_ss")) : "0").doubleValue();
    		dCcfAmountSs += Double.valueOf(null != record.get("ccfAmount_ss") ? String.valueOf(record.get("ccfAmount_ss")) : "0").doubleValue();
    		dZgfAmountSs += Double.valueOf(null != record.get("zgfAmount_ss") ? String.valueOf(record.get("zgfAmount_ss")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("dailyDate", "统计：");
    	jo.put("netWeight", dNetWeight);//净重
    	jo.put("sumAmount", dSumAmount);//总费用
    	jo.put("sqAmount", dSqAmount);//森桥总费用
    	jo.put("fdAmount", dFdAmount);//福地总费用
    	jo.put("ccfAmount", dCcfAmount);//仓储费
    	jo.put("ccfAmount_yj", dCcfAmountYj);//仓储费月结
    	jo.put("ccfAmount_ss", dCcfAmountSs);//仓储费实时
    	jo.put("wsfAmount", dWsfAmount);//卫生费
    	jo.put("glfAmount", dGlfAmount);//管理费
    	jo.put("tcfAmount", dTcfAmount);//停车费
    	jo.put("tcfAmount_yj", dTcfAmountYj);//停车费月结
    	jo.put("tcfAmount_ss", dTcfAmountSs);//停车费实时
    	jo.put("dhfAmount", dDhfAmount);//倒货费
    	jo.put("ydfAmount", dYdfAmount);//运抵费
    	jo.put("zxfAmount", dZxfAmount);//装卸费
    	jo.put("zgfAmount", dZgfAmount);//转关费
    	jo.put("zgfAmount_yj", dZgfAmountYj);//转关费月结
    	jo.put("zgfAmount_ss", dZgfAmountSs);//转关费实时
    	jo.put("khyhfAmount", dKhyhfAmount);//客户优惠
    	jo.put("qtfAmount", dQtfAmount);//其他费用
    	jo.put("payedAmount", dPayedAmount);//实时收费小计
    	jo.put("cashAmount", dCashAmount);//现金收费小计
    	jo.put("nonPayAmount", dNonPayAmount);//月结收费小计
    	ja.add(jo);
    	return ja;
    }
    /**
     * 福地日报表统计页脚
     * @param records
     * @return
     */
    private JSONArray appendFooterDailyReport4Fd(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dNetWeight=0d,dSumAmount=0d,dCcfAmount=0d,dQtfAmount=0d,dCashAmount=0d,dPayedAmount=0d,dNonPayAmount=0d,dKhyhfAmount=0d;
    	for(HashMap<String,Object> record : records){
    		dNetWeight += Double.valueOf(null != record.get("netWeight") ? String.valueOf(record.get("netWeight")) : "0").doubleValue();
    		dSumAmount += Double.valueOf(null != record.get("sumAmount") ? String.valueOf(record.get("sumAmount")) : "0").doubleValue();
    		dCcfAmount += Double.valueOf(null != record.get("ccfAmount") ? String.valueOf(record.get("ccfAmount")) : "0").doubleValue();
    		dKhyhfAmount += Double.valueOf(null != record.get("khyhfAmount") ? String.valueOf(record.get("khyhfAmount")) : "0").doubleValue();
    		dQtfAmount += Double.valueOf(null != record.get("qtfAmount") ? String.valueOf(record.get("qtfAmount")) : "0").doubleValue();
    		dPayedAmount += Double.valueOf(null != record.get("payedAmount") ? String.valueOf(record.get("payedAmount")) : "0").doubleValue();
    		dNonPayAmount += Double.valueOf(null != record.get("nonPayAmount") ? String.valueOf(record.get("nonPayAmount")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("inTime", "统计：");
    	jo.put("netWeight", dNetWeight);//重量
    	jo.put("sumAmount", dSumAmount);//总费用
    	jo.put("ccfAmount", dCcfAmount);//仓储费
    	jo.put("khyhfAmount", dKhyhfAmount);//客户优惠
    	jo.put("qtfAmount", dQtfAmount);//其他费用
    	jo.put("payedAmount", dPayedAmount);//实时收费小计
    	jo.put("cashAmount", dCashAmount);//现金收费小计
    	jo.put("nonPayAmount", dNonPayAmount);//月结收费小计
    	ja.add(jo);
    	return ja;
    }
    
    /**
     * 客户回款进度统计页脚
     * @param records
     * @return
     */
    private JSONArray appendFooterCustomerReturnMoney(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dNonPayAmount=0d,dBackAmount=0d,dOverAmount=0d,dBalanceAmount=0d;
    	for(HashMap<String,Object> record : records){
    		dNonPayAmount += Double.valueOf(null != record.get("nonPayAmount") ? String.valueOf(record.get("nonPayAmount")) : "0").doubleValue();
    		dBackAmount += Double.valueOf(null != record.get("backAmount") ? String.valueOf(record.get("backAmount")) : "0").doubleValue();
    		dOverAmount += Double.valueOf(null != record.get("overAmount") ? String.valueOf(record.get("overAmount")) : "0").doubleValue();
    		dBalanceAmount += Double.valueOf(null != record.get("balanceAmount") ? String.valueOf(record.get("balanceAmount")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("customerName", "统计：");
    	jo.put("nonPayAmount", dNonPayAmount);//月结金额
    	jo.put("backAmount", dBackAmount);//已回款金额
    	jo.put("overAmount", dOverAmount);//超期回款金额
    	jo.put("balanceAmount", dBalanceAmount);//欠款金额
    	ja.add(jo);
    	return ja;
    }
    
    /**
     * 货物出入库报表统计页脚
     * @param records
     * @return
     */
    private JSONArray appendFooterDailyReport4StoreDetailList(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dSumNet=0d,dSumAmount=0d;
    	for(HashMap<String,Object> record : records){
    		dSumNet += Double.valueOf(null != record.get("sumNet") ? String.valueOf(record.get("sumNet")) : "0").doubleValue();
    		dSumAmount += Double.valueOf(null != record.get("sumAmount") ? String.valueOf(record.get("sumAmount")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("carNo", "统计：");
    	jo.put("sumNet", dSumNet);//货物净重
    	jo.put("sumAmount", dSumAmount);//货物数量
    	ja.add(jo);
    	return ja;
    }
    
    /**
     * 以客户和库房维度查询货物出入库报表
     * @param records
     * @return
     */
    private JSONArray appendFooterDailyReport4CustomerStoreList(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dInCount=0d,dOutCount=0d,dGoodsInNet=0d,dGoodsOutNet=0d,dGoodsInAmount=0d,dGoodsOutAmount=0d;
    	for(HashMap<String,Object> record : records){
    		dInCount += Double.valueOf(null != record.get("inCount") ? String.valueOf(record.get("inCount")) : "0").doubleValue();
    		dOutCount += Double.valueOf(null != record.get("outCount") ? String.valueOf(record.get("outCount")) : "0").doubleValue();
    		dGoodsInNet += Double.valueOf(null != record.get("goodsInNet") ? String.valueOf(record.get("goodsInNet")) : "0").doubleValue();
    		dGoodsOutNet += Double.valueOf(null != record.get("goodsOutNet") ? String.valueOf(record.get("goodsOutNet")) : "0").doubleValue();
    		dGoodsInAmount += Double.valueOf(null != record.get("goodsInAmount") ? String.valueOf(record.get("goodsInAmount")) : "0").doubleValue();
    		dGoodsOutAmount += Double.valueOf(null != record.get("goodsOutAmount") ? String.valueOf(record.get("goodsOutAmount")) : "0").doubleValue();
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("storeName", "统计：");
    	jo.put("inCount", dInCount);//入库车数
    	jo.put("outCount", dOutCount);//出库车数
    	jo.put("goodsInNet", dGoodsInNet);//入库货物净重(吨)
    	jo.put("goodsOutNet", dGoodsOutNet);//出库货物净重(吨)
    	jo.put("goodsInAmount", dGoodsInAmount);//入库货物数量
    	jo.put("goodsOutAmount", dGoodsOutAmount);//出库货物数量
    	ja.add(jo);
    	return ja;
    }
}
