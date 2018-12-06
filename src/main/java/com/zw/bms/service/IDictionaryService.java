package com.zw.bms.service;

import com.zw.bms.commons.result.Tree;
import com.zw.bms.model.Dictionary;
import com.zw.bms.model.Resource;

import java.util.List;

import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-10
 */
public interface IDictionaryService extends IService<Dictionary> {
	/**
	 * 字典管理查询列表，字典状态为 除删除的所有状态
	 * @param di
	 * @return
	 */
	List<Dictionary> selectAll(Dictionary di);
	
	/**
	 * 下拉选择查询，字典为正常生效的状态
	 * @return
	 */
	List<Tree> selectTree();
	
	/**
	 * 新增和修改时的保存校验
	 * @param dictionary
	 * @return
	 */
	String validData(Dictionary dictionary);
	
	/**
	 * 下拉选择查询，通过字典编码获取字典项，字典为正常状态
	 * @param code
	 * @return
	 */
	List<Dictionary> selectDictionaryByCode(String code);
}
