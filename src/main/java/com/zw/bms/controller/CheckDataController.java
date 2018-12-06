package com.zw.bms.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.commons.base.BaseController;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.commons.utils.ShiroUtils;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.model.ImportCcjl;
import com.zw.bms.model.ImportRcjl;
import com.zw.bms.model.MatchCcjl;
import com.zw.bms.model.MatchRcjl;
import com.zw.bms.model.UploadFile;
import com.zw.bms.service.IImportCcjlService;
import com.zw.bms.service.IImportRcjlService;
import com.zw.bms.service.IMatchCcjlService;
import com.zw.bms.service.IMatchRcjlService;

/**
 * <p>
 * 海关数据校验前端控制器
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Controller
@RequestMapping("/checkData")
public class CheckDataController extends BaseController {

    @Autowired 
    private IImportCcjlService importCcjlService;
    @Autowired 
    private IImportRcjlService importRcjlService;
    @Autowired
    private IMatchCcjlService matchCcjlService;
    @Autowired
    private IMatchRcjlService matchRcjlService;
    
    /**
     * 海关出仓数据页面
     * @param model
     * @return
     */
    @RequestMapping("/importCcDataListPage")
    public String importCcDataListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/checkData/importCcDataList";
    }
    
    /**
     * 海关入仓数据页面
     * @param model
     * @return
     */
    @RequestMapping("/importRcDataListPage")
    public String importRcDataListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/checkData/importRcDataList";
    }
    
    /**
     * 查询导入的海关出仓数据
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param location
     * @param dateStart
     * @param dateEnd
     * @return
     */
    @RequestMapping("/queryImportCcDataList")
    @ResponseBody
    public PageInfo queryImportCcDataList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "dateStart",required=false) String dateStart,
    		@RequestParam(value = "dateEnd",required=false) String dateEnd) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", dateStart);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(dateEnd) ? DateUtil.getDayAfter(dateEnd) : null);//日期后一天
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	pages.setRecords(importCcjlService.selectCcDataList(pages,paramMap));
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 查询导入的海关入仓数据
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param location
     * @param dateStart
     * @param dateEnd
     * @return
     */
    @RequestMapping("/queryImportRcDataList")
    @ResponseBody
    public PageInfo queryImportRcDataList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "dateStart",required=false) String dateStart,
    		@RequestParam(value = "dateEnd",required=false) String dateEnd) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", dateStart);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(dateEnd) ? DateUtil.getDayAfter(dateEnd) : null);//日期后一天
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	pages.setRecords(importRcjlService.selectRcDataList(pages,paramMap));
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 海关出仓导入页面
     * @return
     */
    @RequestMapping("/importCcDataPage")
    public String importCcDataPage() {
    	return "bi/checkData/importCcData";
    }
    
    /**
     * 海关入仓导入页面
     * @return
     */
    @RequestMapping("/importRcDataPage")
    public String importRcDataPage() {
        return "bi/checkData/importRcData";
    }
    
    /**
     * 导入海关出仓数据
     * @param request
     * @param uploadFile
     * @param multipartFile
     * @return
     */
    @RequestMapping("/importCcDataExcel")
    @ResponseBody
    public Object importCcDataExcel(HttpServletRequest request,UploadFile uploadFile,
    		@RequestParam(value = "file") MultipartFile multipartFile){
    	if(null == multipartFile){
    		return renderError("未获取到导入文件");
    	}
    	String fileName = multipartFile.getOriginalFilename();//上传的文件名
    	String fileEx = fileName.substring(fileName.lastIndexOf("."), fileName.length());//文件后缀名
    	if(!fileEx.equals(".xls") && !fileEx.equals(".xlsx")){
    		return renderError("导入的文件应该以.xls或.xlsx为后缀！");
    	}
    	try{
    		importCcjlService.importCcDataExcel(multipartFile, uploadFile);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	return renderSuccess("出仓数据导入成功！");
    }
    
    /**
     * 导入海关入仓数据
     * @param request
     * @param uploadFile
     * @param multipartFile
     * @return
     */
    @RequestMapping("/importRcDataExcel")
    @ResponseBody
    public Object importRcDataExcel(HttpServletRequest request,UploadFile uploadFile,
    		@RequestParam(value = "file") MultipartFile multipartFile){
    	if(null == multipartFile){
    		return renderError("未获取到导入文件");
    	}
    	String fileName = multipartFile.getOriginalFilename();//上传的文件名
    	String fileEx = fileName.substring(fileName.lastIndexOf("."), fileName.length());//文件后缀名
    	if(!fileEx.equals(".xls") && !fileEx.equals(".xlsx")){
    		return renderError("导入的文件应该以.xls或.xlsx为后缀！");
    	}
    	try{
    		importRcjlService.importRcDataExcel(multipartFile, uploadFile);
    	}catch(Exception e){
    		return renderError(e.getMessage());
    	}
    	return renderSuccess("入仓数据导入成功！");
    }
    
    /**
     * 出仓数据匹配页面
     * @param model
     * @return
     */
    @RequestMapping("/matchCcDataListPage")
    public String matchCcDataListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/checkData/matchCcDataList";
    }
    
    /**
     * 入仓数据匹配页面
     * @param model
     * @return
     */
    @RequestMapping("/matchRcDataListPage")
    public String matchRcDataListPage(Model model) {
    	model.addAttribute("location",ShiroUtils.getShiroUser().getLocation());
        return "bi/checkData/matchRcDataList";
    }
    
    /**
     * 查询出仓数据匹配列表
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param location
     * @param busiDate
     * @param matchType
     * @return
     */
    @RequestMapping("/queryMatchCcDataList")
    @ResponseBody
    public PageInfo queryMatchCcDataList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "busiDate",required=false) String busiDate,
    		@RequestParam(value = "matchType",required=false) String matchType) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", busiDate);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(busiDate) ? DateUtil.getDayAfter(busiDate) : null);
    	paramMap.put("matchType", matchType);
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String, Object>> dataList = Collections.emptyList(); 
    	if(StringUtils.isNotBlank(location) && StringUtils.isNotBlank(busiDate)){//当所属区域和日期为空时返回
    		dataList = matchCcjlService.selectMatchCcDataList(pages,paramMap);
    	}
    	pages.setRecords(dataList);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 手动匹配出仓数据页面
     * @param model
     * @param ccId
     * @param ccNo
     * @param mtId
     * @param ccsj
     * @param location
     * @return
     */
    @RequestMapping("/manualMatchCcDataPage")
    public String manualMatchCcDataPage(Model model,
    		@RequestParam(value = "ccId",required=false) String ccId,
    		@RequestParam(value = "ccNo",required=false) String ccNo,
    		@RequestParam(value = "mtId",required=false) String mtId,
    		@RequestParam(value = "ccsj",required=false) String ccsj,
    		@RequestParam(value = "location",required=false) String location) {
    	MatchCcjl matchCcjl = null;
    	if(StringUtils.isNotBlank(mtId)){
    		matchCcjl = matchCcjlService.selectById(mtId);
    	}
    	model.addAttribute("matchCcData",matchCcjl);
    	model.addAttribute("ccId",ccId);
    	model.addAttribute("ccNo",ccNo);
    	model.addAttribute("ccsj",DateUtil.getDateFormat(DateUtil.getDateTimeFormat(ccsj)));
    	model.addAttribute("location",location);
        return "bi/checkData/manualMatchCcData";
    }
    
    
    /**
     * 处理出仓自动匹配
     * @param request
     * @param location
     * @param carNo
     * @param busiDate
     * @return
     */
    @RequestMapping("/dealAutoMatchCcData")
    @ResponseBody
    public Object dealAutoMatchCcData(HttpServletRequest request,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "busiDate",required=false) String busiDate){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", location);
    	paramMap.put("carNo", carNo);
    	paramMap.put("dateStart", busiDate);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(busiDate) ? DateUtil.getDayAfter(busiDate) : null);
    	paramMap.put("matchType", "0"); //出仓数据为未匹配数据 
    	try{
    		matchCcjlService.dealAutoMatchCcData(paramMap);
    	}catch(Exception e){
    		return renderSuccess(e.getMessage());
    	}
    	return renderSuccess("自动匹配出仓数据成功！");
    }
    
    /**
     * 处理手动出仓匹配信息
     * @param request
     * @param matchCcjl
     * @return
     */
    @RequestMapping("/dealManualMatchCcData")
    @ResponseBody
    public Object dealManualMatchCcData(HttpServletRequest request,MatchCcjl matchCcjl){
    	matchCcjl.setCreateTime(StringUtils.isNotBlank(matchCcjl.getCreateTime()) ? matchCcjl.getCreateTime() : DateUtil.getNowDateTimeString());
    	matchCcjl.setCreateUser(StringUtils.isNotBlank(matchCcjl.getCreateUser()) ? matchCcjl.getCreateUser() : ShiroUtils.getLoginName());
    	matchCcjl.setUpdateTime(DateUtil.getNowDateTimeString());
    	matchCcjl.setUpdateUser(ShiroUtils.getLoginName());
    	matchCcjl.setType("2");//手动匹配
    	if(null == matchCcjl.getCarId() || matchCcjl.getCarId() == 0){
    		matchCcjl.setCarId(null);
    		matchCcjl.setType("3");//无车匹配
    	}
    	try{
    		if(null == matchCcjl.getId()){
        		matchCcjlService.insert(matchCcjl);
        	}else{
        		matchCcjlService.updateAllColumnById(matchCcjl);
        	}
    	}catch(Exception e){
    		return renderError("手动匹配失败！" + e.getMessage());
    	}
    	return renderSuccess("手动匹配成功！");
    }
    
    /**
     * 手动匹配出仓关联出库车辆页面
     * @param model
     * @param ccsj
     * @param location
     * @return
     */
    @RequestMapping("/selectMatchCcPickListPage")
    public String selectMatchCcDataListPage(Model model,
    		@RequestParam(value = "ccsj",required=false) String ccsj,
    		@RequestParam(value = "location",required=false) String location) {
    	model.addAttribute("ccsj",ccsj);
    	model.addAttribute("location",location);
        return "bi/checkData/selectMatchCcPickList";
    }
    
    /**
     * 手动匹配时关联出库车辆列表
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param ccsj
     * @param location
     * @return
     */
    @RequestMapping("/selectMatchCcPickList")
    @ResponseBody
    public PageInfo selectMatchCcPickList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "ccsj",required=false) String ccsj,
    		@RequestParam(value = "location",required=false) String location) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", ccsj);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(ccsj) ? DateUtil.getDayAfter(ccsj) : null);
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String, Object>> dataList = Collections.emptyList();
    	if(StringUtils.isNotBlank(location) && StringUtils.isNotBlank(ccsj)){//当所属区域和日期为空时返回
    		dataList = matchCcjlService.selectMatchCcPickList(pages,paramMap);
    	}
    	pages.setRecords(dataList);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    } 
    
    /**
     * 查询入仓数据匹配列表
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param location
     * @param busiDate
     * @param matchType
     * @return
     */
    @RequestMapping("/queryMatchRcDataList")
    @ResponseBody
    public PageInfo queryMatchRcDataList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "busiDate",required=false) String busiDate,
    		@RequestParam(value = "matchType",required=false) String matchType) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", busiDate);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(busiDate) ? DateUtil.getDayAfter(busiDate) : null);
    	paramMap.put("matchType", matchType);
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String, Object>> dataList = Collections.emptyList(); 
    	if(StringUtils.isNotBlank(location) && StringUtils.isNotBlank(busiDate)){//当所属区域和日期为空时返回
    		dataList = matchRcjlService.selectMatchRcDataList(pages,paramMap);
    	}
    	pages.setRecords(dataList);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 手动匹配入仓数据页面
     * @param model
     * @param ccId
     * @param ccNo
     * @param mtId
     * @param rcsj
     * @param location
     * @return
     */
    @RequestMapping("/manualMatchRcDataPage")
    public String manualMatchRcDataPage(Model model,
    		@RequestParam(value = "rcId",required=false) String rcId,
    		@RequestParam(value = "rcNo",required=false) String rcNo,
    		@RequestParam(value = "mtId",required=false) String mtId,
    		@RequestParam(value = "rcsj",required=false) String rcsj,
    		@RequestParam(value = "location",required=false) String location) {
    	MatchRcjl matchRcjl = null;
    	if(StringUtils.isNotBlank(mtId)){
    		matchRcjl = matchRcjlService.selectById(mtId);
    	}
    	model.addAttribute("matchRcData",matchRcjl);
    	model.addAttribute("rcId",rcId);
    	model.addAttribute("rcNo",rcNo);
    	model.addAttribute("rcsj",DateUtil.getDateFormat(DateUtil.getDateTimeFormat(rcsj)));
    	model.addAttribute("location",location);
        return "bi/checkData/manualMatchRcData";
    }
    
    
    /**
     * 处理入仓自动匹配
     * @param request
     * @param location
     * @param carNo
     * @param busiDate
     * @return
     */
    @RequestMapping("/dealAutoMatchRcData")
    @ResponseBody
    public Object dealAutoMatchRcData(HttpServletRequest request,
    		@RequestParam(value = "location",required=false) String location,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "busiDate",required=false) String busiDate){
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("location", location);
    	paramMap.put("carNo", carNo);
    	paramMap.put("dateStart", busiDate);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(busiDate) ? DateUtil.getDayAfter(busiDate) : null);
    	paramMap.put("matchType", "0"); //入仓数据为未匹配数据 
    	try{
    		matchRcjlService.dealAutoMatchRcData(paramMap);
    	}catch(Exception e){
    		return renderSuccess(e.getMessage());
    	}
    	return renderSuccess("自动匹配入仓数据成功！");
    }
    
    /**
     * 处理手动出仓匹配信息
     * @param request
     * @param matchCcjl
     * @return
     */
    @RequestMapping("/dealManualMatchRcData")
    @ResponseBody
    public Object dealManualMatchRcData(HttpServletRequest request,MatchRcjl matchRcjl){
    	matchRcjl.setCreateTime(StringUtils.isNotBlank(matchRcjl.getCreateTime()) ? matchRcjl.getCreateTime() : DateUtil.getNowDateTimeString());
    	matchRcjl.setCreateUser(StringUtils.isNotBlank(matchRcjl.getCreateUser()) ? matchRcjl.getCreateUser() : ShiroUtils.getLoginName());
    	matchRcjl.setUpdateTime(DateUtil.getNowDateTimeString());
    	matchRcjl.setUpdateUser(ShiroUtils.getLoginName());
    	matchRcjl.setType("2");//手动匹配
    	if(null == matchRcjl.getCarId() || matchRcjl.getCarId() == 0){
    		matchRcjl.setCarId(null);
    		matchRcjl.setType("3");//无车匹配
    	}
    	try{
    		if(null == matchRcjl.getId()){
        		matchRcjlService.insert(matchRcjl);
        	}else{
        		matchRcjlService.updateAllColumnById(matchRcjl);
        	}
    	}catch(Exception e){
    		return renderError("手动匹配失败！" + e.getMessage());
    	}
    	return renderSuccess("手动匹配成功！");
    }
    
    /**
     * 手动匹配出仓关联出库车辆页面
     * @param model
     * @param ccsj
     * @param location
     * @return
     */
    @RequestMapping("/selectMatchRcPickListPage")
    public String selectMatchRcDataListPage(Model model,
    		@RequestParam(value = "rcsj",required=false) String rcsj,
    		@RequestParam(value = "location",required=false) String location) {
    	model.addAttribute("rcsj",rcsj);
    	model.addAttribute("location",location);
        return "bi/checkData/selectMatchRcPickList";
    }
    
    /**
     * 手动匹配时关联出库车辆列表
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @param carNo
     * @param ccsj
     * @param location
     * @return
     */
    @RequestMapping("/selectMatchRcPickList")
    @ResponseBody
    public PageInfo selectMatchRcPickList(Integer page, Integer rows, String sort,String order,
    		@RequestParam(value = "carNo",required=false) String carNo,
    		@RequestParam(value = "rcsj",required=false) String rcsj,
    		@RequestParam(value = "location",required=false) String location) {
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();//form表单参数
    	paramMap.put("carNo", carNo);
    	paramMap.put("location", StringUtils.isNotBlank(location) ? location : ShiroUtils.getShiroUser().getLocation());
    	paramMap.put("dateStart", rcsj);
    	paramMap.put("dateEnd", StringUtils.isNotBlank(rcsj) ? DateUtil.getDayAfter(rcsj) : null);
    	PageInfo pageInfo = new PageInfo(page, rows, sort, order);
    	Page<HashMap<String,Object>> pages = getPage(page, rows, sort, order);
    	List<HashMap<String, Object>> dataList = Collections.emptyList();
    	if(StringUtils.isNotBlank(location) && StringUtils.isNotBlank(rcsj)){//当所属区域和日期为空时返回
    		dataList = matchRcjlService.selectMatchRcPickList(pages,paramMap);
    	}
    	pages.setRecords(dataList);
    	pageInfo.setRows(pages.getRecords());
    	pageInfo.setTotal(pages.getTotal());
    	return pageInfo;
    }
    
    /**
     * 查询出仓数据明细
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/viewImportCcDetail")
    public String viewImportCcDetail(Model model,@RequestParam(value = "id",required=false) Long id) {
    	ImportCcjl detail = null;
    	if(null != id && id > 0){
    		detail = importCcjlService.selectById(id);
    	}
    	model.addAttribute("detail",detail);
        return "bi/checkData/viewImportCcDetail";
    }
    
    /**
     * 查看出仓导入数据明细
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/viewImportRcDetail")
    public String viewImportRcDetail(Model model,@RequestParam(value = "id",required=false) Long id) {
    	ImportRcjl detail = null;
    	if(null != id && id > 0){
    		detail = importRcjlService.selectById(id);
    	}
    	model.addAttribute("detail",detail);
        return "bi/checkData/viewImportRcDetail";
    }
}
