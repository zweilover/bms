package com.zw.bms.service.impl;

import com.zw.bms.model.ImportRcjl;
import com.zw.bms.model.UploadFile;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.mapper.ImportRcjlMapper;
import com.zw.bms.service.IImportRcjlService;
import com.zw.bms.service.IUploadFileService;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

/**
 * <p>
 * 海关系统入仓记录 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Service
public class ImportRcjlServiceImpl extends ServiceImpl<ImportRcjlMapper, ImportRcjl> implements IImportRcjlService {

	@Autowired
	private IUploadFileService uploadFileService;
	
	@Autowired
	private ImportRcjlMapper importRcjlMapper;
	
	
	@Override
	@Transactional
	public void importRcDataExcel(MultipartFile file, UploadFile uploadFile) {
		//1、上传并保存附件信息
		//2、解析Excel
		//3、保存解析的入仓记录
		uploadFileService.saveAndUploadFileInfo(uploadFile, file);
		saveExcelData4Cc(uploadFile,uploadFileService.readExcel4ImportFile(uploadFile));
	}

	@Override
	public List<HashMap<String, Object>> selectRcDataList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return importRcjlMapper.selectRcDataList(page, queryParam);
	}
	
	/**
	 * 解析并保存出仓记录
	 * @param uploadFile
	 * @param list
	 */
	public void saveExcelData4Cc(UploadFile uploadFile,ArrayList<ArrayList<String>> list){
		ImportRcjl rcjl = null;
		ArrayList<String> rowData = null;
		List<ImportRcjl> rcjlList = new ArrayList<ImportRcjl>();
		for(int i = 1 ;i < list.size();i++){//跳过第一行表头
			rowData = list.get(i);
			rcjl = new ImportRcjl();
			rcjl.setFileId(uploadFile.getId());//关联文件ID
			rcjl.setCreateTime(uploadFile.getCreateTime());//创建日期
			rcjl.setCreateUser(uploadFile.getCreateUser());//创建人
			rcjl.setRcid(Long.valueOf(rowData.get(1)));//入仓ID
			rcjl.setZt(rowData.get(2));//状态
			rcjl.setCkmc(rowData.get(3));//仓库名称
			rcjl.setCh(rowData.get(4));//车号
			rcjl.setCzts(rowData.get(7));//操作提示
			rcjl.setKadbm(rowData.get(8));//口岸地编码
			rcjl.setCkbm(rowData.get(9));//仓库编码
			rcjl.setCkbzxx(rowData.get(10));//次卡备注信息
			rcjl.setRcsj(DateUtil.converDateFormat(rowData.get(11),"yyyy/MM/ddhh:mm:ss",DateUtil.DATETIME_DEFAULT_FORMAT));//入仓时间
			rcjl.setTdbh(rowData.get(12));//通道编号
			rcjl.setTdlx(rowData.get(13));//通道类型
			rcjl.setKh(rowData.get(14));//卡号
			rcjl.setYtklx(rowData.get(15));//运通卡类型
			rcjl.setCllx(rowData.get(16));//车辆类型
			rcjl.setSsch(rowData.get(17));//手输车号
			rcjl.setZpch(rowData.get(18));//抓拍车号
			rcjl.setTglx(rowData.get(19));//通关类型
			rcjl.setClbazl(rowData.get(20));//车辆备案重量
			rcjl.setDbcjzl(rowData.get(21));//地磅采集重量
			rcjl.setHwjz(rowData.get(22));//货物净重
			rcjl.setGpsbh(rowData.get(23));//GPS编号
			rcjl.setDzsbh1(rowData.get(24));//电子锁编号1
			rcjl.setDzsbh2(rowData.get(25));//电子锁编号2
			rcjl.setDzcp1(rowData.get(26));//电子车牌1
			rcjl.setDzcp2(rowData.get(27));//电子车牌2
			rcjl.setLrr(rowData.get(28));//录入人
			rcjl.setCzdnm(rowData.get(29));//操作电脑名
			rcjl.setCzdnip(rowData.get(30));//操作电脑IP
			rcjl.setJhbz(rowData.get(31));//交互标识
			rcjl.setBz(rowData.get(32));//备注
			rcjlList.add(rcjl);
		}
		this.insertBatch(rcjlList);
	}
	
}
