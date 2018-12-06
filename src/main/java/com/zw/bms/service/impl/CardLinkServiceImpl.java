package com.zw.bms.service.impl;

import com.zw.bms.model.CardLink;
import com.zw.bms.commons.exception.CommonException;
import com.zw.bms.mapper.CardLinkMapper;
import com.zw.bms.service.ICardLinkService;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 运通卡关联表 服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-01
 */
@Service
public class CardLinkServiceImpl extends ServiceImpl<CardLinkMapper, CardLink> implements ICardLinkService {

	@Autowired
	private CardLinkMapper cardLinkMapper;
	
	@Override
	public void checkUnique4CardNo(CardLink cardLink) {
		Integer i = 0;
		EntityWrapper<CardLink> ew = new EntityWrapper<CardLink>();
		ew.and(" status = 0 AND card_no = {0}",cardLink.getCardNo());
		if(null != cardLink.getId() && cardLink.getId() > 0){
			ew.and(" id != {0}",cardLink.getId());
		}
		i = cardLinkMapper.selectCount(ew);
		if(i > 0){
			throw new CommonException("已存在相同的运通卡号，请确认！");
		}
	}
	
}
