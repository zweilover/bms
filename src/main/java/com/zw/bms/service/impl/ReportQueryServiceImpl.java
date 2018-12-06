package com.zw.bms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.plugins.Page;
import com.zw.bms.mapper.ReportQueryMapper;
import com.zw.bms.model.CarInfo;
import com.zw.bms.service.IReportQueryService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author zhaiwei
 * @since 2018-01-09
 */
@Service
public class ReportQueryServiceImpl implements IReportQueryService {
	@Autowired
	private ReportQueryMapper reportQueryMapper;
	
	public List<HashMap<String,Object>> queryCarInfoReport(Page<HashMap<String,Object>> page,Map<String,Object> queryParam){
		return reportQueryMapper.queryCarInfoReport(page,queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryCustAccountReport(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryCustAccountReport(page, queryParam);
	}
	
	@Override
	public List<HashMap<String, Object>> queryCustAccountDetailReport(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryCustAccountDetailReport(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryDailyReport4SqList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryDailyReport4SqList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryMonthlyReport4SqList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryMonthlyReport4SqList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryYearReport4SqList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryYearReport4SqList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryDailyReport4FdList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryDailyReport4FdList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryCustomerReturnMoneyList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryCustomerReturnMoneyList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryDailyReport4StoreDetailList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		return reportQueryMapper.queryDailyReport4StoreDetailList(page, queryParam);
	}

	@Override
	public List<HashMap<String, Object>> queryDailyReport4CustomerStoreList(Page<HashMap<String, Object>> page,
			Map<String, Object> queryParam) {
		// TODO Auto-generated method stub
		return reportQueryMapper.queryDailyReport4CustomerStoreList(page, queryParam);
	}
}
