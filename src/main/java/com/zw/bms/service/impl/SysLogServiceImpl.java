package com.zw.bms.service.impl;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.zw.bms.commons.result.PageInfo;
import com.zw.bms.mapper.SysLogMapper;
import com.zw.bms.model.SysLog;
import com.zw.bms.service.ISysLogService;

/**
 *
 * SysLog 表数据服务层接口实现类
 *
 */
@Service
public class SysLogServiceImpl extends ServiceImpl<SysLogMapper, SysLog> implements ISysLogService {
    
    @Override
    public void selectDataGrid(PageInfo pageInfo) {
        Page<SysLog> page = new Page<SysLog>(pageInfo.getNowpage(), pageInfo.getSize());
        EntityWrapper<SysLog> wrapper = new EntityWrapper<SysLog>();
        wrapper.orderBy(pageInfo.getSort(), pageInfo.getOrder().equalsIgnoreCase("ASC"));
        selectPage(page, wrapper);
        pageInfo.setRows(page.getRecords());
        pageInfo.setTotal(page.getTotal());
    }
    
}