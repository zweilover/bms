package com.zw.bms.service;

import com.zw.bms.model.UploadFile;
import java.util.ArrayList;
import org.springframework.web.multipart.MultipartFile;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 文件上传表 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
public interface IUploadFileService extends IService<UploadFile> {
	
	/**
	 * 保存并上传附件信息
	 * @param uploadFile
	 * @param file
	 * @return
	 */
	boolean saveAndUploadFileInfo(UploadFile uploadFile,MultipartFile file);
	
	/**
	 * 解析导入的Excel文件
	 * @param uploadFile
	 * @return
	 */
	ArrayList<ArrayList<String>> readExcel4ImportFile(UploadFile uploadFile);
}
