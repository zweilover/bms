package com.zw.bms.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.result.Tree;
import com.zw.bms.commons.utils.StringUtils;
import com.zw.bms.mapper.DictionaryMapper;
import com.zw.bms.model.Dictionary;
import com.zw.bms.service.IDictionaryService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-10
 */
@Service
public class DictionaryServiceImpl extends ServiceImpl<DictionaryMapper, Dictionary> implements IDictionaryService {

	@Autowired
    private DictionaryMapper dictionaryMapper;
	
	@Override
	public List<Dictionary> selectAll(Dictionary di) {
		EntityWrapper<Dictionary> wrapper = new EntityWrapper<Dictionary>();
        wrapper.orderBy("seq");
        wrapper.and("status in ('0','1')");
        if(StringUtils.isNotBlank(di.getName())){
        	wrapper.like("name", di.getName());
        }
        if(StringUtils.isNotBlank(di.getCode())){
        	wrapper.like("code", di.getCode());
        }
        return dictionaryMapper.selectList(wrapper);
	}

	@Override
	public List<Tree> selectTree() {
		List<Dictionary> dicList = selectLevleTree();
		List<Tree> trees = new ArrayList<Tree>();
		if(null != dicList){
			Tree tree = null;
			for(Dictionary dic : dicList){
				tree = new Tree();
				 tree.setId(dic.getId());
	             tree.setText(dic.getName());
	             tree.setPid(dic.getPid());
	             trees.add(tree);
			}
		}
		return trees;
	}
	
	public List<Dictionary> selectLevleTree(){
		EntityWrapper<Dictionary> wrapper = new EntityWrapper<Dictionary>();
		wrapper.orderBy("seq");
		wrapper.and("status = {0}", String.valueOf("0"));
//		wrapper.isNull("pid");
		return dictionaryMapper.selectList(wrapper);
	}

	/***
	 * 校验字典名称和编码是否重复
	 */
	@Override
	public String validData(Dictionary dictionary) {
		Integer i = 0;
		if(StringUtils.isNotBlank(dictionary.getName())){
			EntityWrapper<Dictionary> wrapper = new EntityWrapper<Dictionary>();
			wrapper.and("status in ('0','1')");
			wrapper.and("name = {0}", dictionary.getName());
			//适用于修改时校验
			if(dictionary.getId() != null && dictionary.getId() != 0){
				wrapper.and("id != {0}", dictionary.getId());
			}
			i = dictionaryMapper.selectCount(wrapper);
			if(i > 0){
				return "字典名称已存在！";
			}
		}
		if(StringUtils.isNotBlank(dictionary.getCode())){
			EntityWrapper<Dictionary> wrapper = new EntityWrapper<Dictionary>();
			wrapper.and("status in ('0','1')");
			wrapper.and("code = {0}", dictionary.getCode().toUpperCase());
			//适用于修改时校验
			if(dictionary.getId() != null && dictionary.getId() != 0){
				wrapper.and("id != {0}", dictionary.getId());
			}
			i = dictionaryMapper.selectCount(wrapper);
			if(i > 0){
				return "字典编码已存在！";
			}
		}
		return null;
	}

	@Override
	public List<Dictionary> selectDictionaryByCode(String code) {
		return dictionaryMapper.selectDictionaryByCode(code);
	}
	
}
