package com.zw.bms.mapper;

import com.zw.bms.model.AccountDetail;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.Page;

/**
 * <p>
  * 客户账户明细 Mapper 接口
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-04
 */
public interface AccountDetailMapper extends BaseMapper<AccountDetail> {
	/**
	 * 获取客户回款列表
	 * @param page
	 * @param detail
	 * @return
	 */
	List<AccountDetail> selectAccountDetailList(Page<AccountDetail> page,@Param("detail")AccountDetail detail);

}