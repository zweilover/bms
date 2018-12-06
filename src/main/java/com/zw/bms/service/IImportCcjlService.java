package com.zw.bms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;
import com.zw.bms.model.ImportCcjl;
import com.zw.bms.model.UploadFile;

/**
 * <p>
 * 海关系统出仓记录 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface IImportCcjlService extends IService<ImportCcjl> {
	
	/**
	 * 导入出仓数据
	 * @param file
	 * @param uploadFile
	 */
	void importCcDataExcel(MultipartFile file,UploadFile uploadFile);
	
	/**
	 * 查询出仓列表
	 * @param page
	 * @param queryParam
	 */
	List<HashMap<String,Object>> selectCcDataList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam);
}
