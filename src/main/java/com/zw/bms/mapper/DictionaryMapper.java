package com.zw.bms.mapper;

import com.zw.bms.model.Dictionary;

import java.util.List;

import com.baomidou.mybatisplus.mapper.BaseMapper;

/**
 * <p>
  *  Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-10
 */
public interface DictionaryMapper extends BaseMapper<Dictionary> {
	List<Dictionary> selectDictionaryByCode(String code);

}