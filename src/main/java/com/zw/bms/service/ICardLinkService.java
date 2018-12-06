package com.zw.bms.service;

import com.zw.bms.model.CardLink;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 * 运通卡关联表 服务类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-08-01
 */
public interface ICardLinkService extends IService<CardLink> {
	/**
	 * 校验运通卡号唯一性
	 * @param cardLink
	 */
	void checkUnique4CardNo(CardLink cardLink);
}
