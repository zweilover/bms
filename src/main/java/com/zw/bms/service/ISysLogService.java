package com.zw.bms.service;

import com.baomidou.mybatisplus.service.IService;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.model.SysLog;

/**
 *
 * SysLog 表数据服务层接口
 *
 */
public interface ISysLogService extends IService<SysLog> {

    void selectDataGrid(PageInfo pageInfo);

}