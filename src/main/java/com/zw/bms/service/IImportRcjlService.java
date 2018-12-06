package com.zw.bms.service;

import com.zw.bms.model.ImportRcjl;
import com.zw.bms.model.UploadFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 海关系统入仓记录 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface IImportRcjlService extends IService<ImportRcjl> {
	
	/**
	 * 导入入仓数据
	 * @param file
	 * @param uploadFile
	 */
	void importRcDataExcel(MultipartFile file,UploadFile uploadFile);
	
	/**
	 * 查询入仓列表
	 * @param page
	 * @param queryParam
	 */
	List<HashMap<String,Object>> selectRcDataList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
	
}
