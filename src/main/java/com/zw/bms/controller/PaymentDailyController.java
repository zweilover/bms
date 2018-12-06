package com.zw.bms.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.service.IPaymentDailyService;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-04-27
 */
@Controller
@RequestMapping("/paymentDaily")
public class PaymentDailyController extends BaseController {

    @Autowired 
    private IPaymentDailyService paymentDailyService;
    
    @RequestMapping("/manager")
    public String manager(Model model) {
    	String str_location = ShiroUtils.getShiroUser().getLocation();
    	String str_startTime,str_endTime = "";
    	if("FD".equals(str_location)){
    		str_startTime = DateUtil.getNowDateString() + " 00:00:00";
    		str_endTime = DateUtil.getNowDateString() + " 23:59:59";
    	}else{
    		str_startTime = DateUtil.getDateFormat(DateUtil.getDayBefore(new Date())) + " 18:30:00";
    		str_endTime = DateUtil.getNowDateString() + " 18:30:00";
    	}
    	model.addAttribute("location", str_location);
    	model.addAttribute("billTimeStart", str_startTime);
    	model.addAttribute("billTimeEnd", str_endTime);
        return "bi/paymentDaily/paymentDailyData";
    }
    
    /**
     * 日账单结转数据查询
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @RequestMapping("/queryPaymentDailyData")
    @ResponseBody
    public PageInfo queryPaymentDailyData(HttpServletRequest request, Integer page, Integer rows, String sort,String order) {
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	String str_location = ShiroUtils.getShiroUser().getLocation();
    	String str_startTime,str_endTime = "";
    	if("FD".equals(str_location)){
    		str_startTime = DateUtil.getNowDateString() + " 00:00:00";
    		str_endTime = DateUtil.getNowDateString() + " 23:59:59";
    	}else{
    		str_startTime = DateUtil.getDateFormat(DateUtil.getDayBefore(new Date())) + " 18:30:00";
    		str_endTime = DateUtil.getNowDateString() + " 18:30:00";
    	}
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", StringUtils.isNotBlank(request.getParameter("location")) ? request.getParameter("location") : str_location );
    	paramMap.put("carNo", StringUtils.isNotBlank(request.getParameter("carNo")) ? request.getParameter("carNo").toUpperCase() : "" );
    	paramMap.put("billTimeStart", StringUtils.isNotBlank(request.getParameter("billTimeStart")) ? request.getParameter("billTimeStart") : str_startTime);
    	paramMap.put("billTimeEnd", StringUtils.isNotBlank(request.getParameter("billTimeEnd")) ? request.getParameter("billTimeEnd") : str_endTime);
    	List<HashMap<String,Object>> records = paymentDailyService.queryPaymentDailyData(pages, paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	pageInfo.setFooter(this.appendFooterPaymentDailyData(records));//增加统计行
        return pageInfo;
    }
    
    /**
     * 账单结转
     * @param request
     * @return
     */
    @RequestMapping("/dealPaymentDaily")
    @ResponseBody
    public Object dealPaymentDaily(@RequestParam(value = "dailyDate",required = true) String dailyDate,
    		@RequestParam(value = "location",required = true) String location,
    		@RequestParam(value = "billTimeStart",required = true) String billTimeStart,
    		@RequestParam(value = "billTimeEnd",required = true) String billTimeEnd){
    	boolean b = true;
    	try{
    		HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    		paramMap.put("dailyDate",dailyDate);
    		paramMap.put("location",location);
        	paramMap.put("billTimeStart",billTimeStart);
        	paramMap.put("billTimeEnd",billTimeEnd);
    		paymentDailyService.dealPaymentDaily(paramMap);
    	}catch(Exception e){
    		b = false;
        	return renderError(e.getMessage());
    	}
    	if (b) {
            return renderSuccess("账单结转成功！");
        } else {
            return renderError("账单结转失败");
        }
    }
    
    /**
     * 结转记录页面
     * @param model
     * @return
     */
    @RequestMapping("/paymentDailyHistoryPage")
    public String dailyHistoryPage(Model model){
    	model.addAttribute("location", ShiroUtils.getShiroUser().getLocation());
    	return "bi/paymentDaily/paymentDailyHistoryList";
    }
    
    /**
     * 查询结转记录
     * @param request
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    @RequestMapping("/queryPaymentDailyHistory")
    @ResponseBody
    public PageInfo queryPaymentDailyHistory(HttpServletRequest request,Model model,Integer page, Integer rows, String sort,String order){
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", StringUtils.isNotBlank(request.getParameter("location")) ? request.getParameter("location") : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dailyDate", request.getParameter("dailyDate"));
    	List<HashMap<String,Object>> records = paymentDailyService.queryPaymentDailyHistory(pages, paramMap);
    	pages.setRecords(records);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
    	return pageInfo;
    }
    
    /**
     * 日账单结转统计页脚
     * @param records
     * @return
     */
    private JSONArray appendFooterPaymentDailyData(List<HashMap<String,Object>> records){
    	JSONArray ja = new JSONArray();//增加统计行
    	if(null == records || records.size() == 0){
    		return ja;
    	}
    	double dNetWeight=0d,dSumAmount=0d,dCcfAmount=0d,dWsfAmount=0d,dGlfAmount=0d;
    	double dTcfAmount=0d,dDhfAmount=0d,dYdfAmount=0d,dZxfAmount=0d,dZgfAmount=0d;
    	double dKhyhfAmount=0d,dQtfAmount=0d,dCashAmount=0d,dPayedAmount=0d,dNonPayAmount=0d;
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
    	}
    	JSONObject jo = new JSONObject();
    	jo.put("billTime", "统计：");
    	jo.put("netWeight", dNetWeight);//净重
    	jo.put("sumAmount", dSumAmount);//总费用
    	jo.put("ccfAmount", dCcfAmount);//仓储费
    	jo.put("wsfAmount", dWsfAmount);//卫生费
    	jo.put("glfAmount", dGlfAmount);//管理费
    	jo.put("tcfAmount", dTcfAmount);//停车费
    	jo.put("dhfAmount", dDhfAmount);//倒货费
    	jo.put("ydfAmount", dYdfAmount);//运抵费
    	jo.put("zxfAmount", dZxfAmount);//装卸费
    	jo.put("zgfAmount", dZgfAmount);//转关费
    	jo.put("khyhfAmount", dKhyhfAmount);//客户优惠
    	jo.put("qtfAmount", dQtfAmount);//其他费用
    	jo.put("payedAmount", dPayedAmount);//实时收费小计
    	jo.put("cashAmount", dCashAmount);//现金收费小计
    	jo.put("nonPayAmount", dNonPayAmount);//月结收费小计
    	ja.add(jo);
    	return ja;
    }
}
