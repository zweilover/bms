package com.zw.bms.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.utils.DateUtil;
import com.zw.bms.mapper.ImportCcjlMapper;
import com.zw.bms.model.ImportCcjl;
import com.zw.bms.model.UploadFile;
import com.zw.bms.service.IImportCcjlService;
import com.zw.bms.service.IUploadFileService;

/**
 * <p>
 * 海关系统出仓记录 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-06-28
 */
@Service
public class ImportCcjlServiceImpl extends ServiceImpl<ImportCcjlMapper, ImportCcjl> implements IImportCcjlService {

	@Autowired
	private ImportCcjlMapper importCcjlMapper;
	
	@Autowired
	private IUploadFileService uploadFileService;
	
	
	@Override
	@Transactional
	public void importCcDataExcel(MultipartFile file, UploadFile uploadFile) {
		//1、上传并保存附件信息
		//2、解析Excel
		//3、保存解析的出仓记录
		uploadFileService.saveAndUploadFileInfo(uploadFile, file);
		saveExcelData4Cc(uploadFile,uploadFileService.readExcel4ImportFile(uploadFile));
	}
	
	@Override
	public List<HashMap<String,Object>> selectCcDataList(Page<HashMap<String,Object>> page,Map<String,Object> queryParam) {
		return importCcjlMapper.selectCcDataList(page, queryParam);
	}
	
	/**
	 * 解析并保存出仓记录
	 * @param uploadFile
	 * @param list
	 */
	public void saveExcelData4Cc(UploadFile uploadFile,ArrayList<ArrayList<String>> list){
		ImportCcjl ccjl = null;
		ArrayList<String> rowData = null;
		List<ImportCcjl> ccjlList = new ArrayList<ImportCcjl>();
		for(int i = 1 ;i < list.size();i++){//跳过第一行表头
			rowData = list.get(i);
			ccjl = new ImportCcjl();
			ccjl.setFileId(uploadFile.getId());//关联文件ID
			ccjl.setCreateTime(uploadFile.getCreateTime());//创建日期
			ccjl.setCreateUser(uploadFile.getCreateUser());//创建人
			ccjl.setCcid(Long.valueOf(rowData.get(1)));//出仓ID
			ccjl.setZt(rowData.get(2));//状态
			ccjl.setBgdh(rowData.get(3));//报关单号
			ccjl.setCzts(rowData.get(4));//操作提示
			ccjl.setKadbm(rowData.get(5));//口岸地编码
			ccjl.setCkbm(rowData.get(6));//仓库编码
			ccjl.setCkmc(rowData.get(7));//仓库名称
			ccjl.setCkbzxx(rowData.get(8));//次卡备注信息
			ccjl.setTgsj(rowData.get(9));//通过时间
			ccjl.setCcsj(DateUtil.converDateFormat(rowData.get(10),"yyyy/MM/dd hh:mm:ss",DateUtil.DATETIME_DEFAULT_FORMAT));//出仓时间
			ccjl.setTdbh(rowData.get(11));//通道编号
			ccjl.setTdlx(rowData.get(12));//通道类型
			ccjl.setKh(rowData.get(13));//卡号
			ccjl.setYtklx(rowData.get(14));//运通卡类型
			ccjl.setCh(rowData.get(15));//车号
			ccjl.setCkdbh(rowData.get(16));//出库单编号
			ccjl.setBggs(rowData.get(17));//报关公司
			ccjl.setCllx(rowData.get(18));//车辆类型
			ccjl.setSsch(rowData.get(19));//手输车号
			ccjl.setZpch(rowData.get(20));//抓拍车号
			ccjl.setTglx(rowData.get(21));//通关类型
			ccjl.setClbazl(rowData.get(22));//车辆备案重量
			ccjl.setDbcjzl(rowData.get(23));//地磅采集重量
			ccjl.setHwjz(rowData.get(24));//货物净重
			ccjl.setGpsbh(rowData.get(25));//GPS编号
			ccjl.setDzsbh1(rowData.get(26));//电子锁编号1
			ccjl.setDzsbh2(rowData.get(27));//电子锁编号2
			ccjl.setDzcp1(rowData.get(28));//电子车牌1
			ccjl.setDzcp2(rowData.get(29));//电子车牌2
			ccjl.setLrr(rowData.get(30));//录入人
			ccjl.setCzdnm(rowData.get(31));//操作电脑名
			ccjl.setCzdnip(rowData.get(32));//操作电脑IP
			ccjl.setJhbz(rowData.get(33));//交互标识
			ccjl.setBz(rowData.get(34));//备注
			ccjlList.add(ccjl);
		}
		this.insertBatch(ccjlList);
	}

}
