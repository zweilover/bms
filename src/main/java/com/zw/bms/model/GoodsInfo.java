package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 货物信息
 * </p>
 *
 * @author zhaiwei
 * @since 2018-09-20
 */
@TableName("bi_goods_info")
public class GoodsInfo extends Model<GoodsInfo> {

    private static final long serialVersionUID = 1L;

    /**
     * ID主键
     */
	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 名称
     */
	private String name;
    /**
     * 排序
     */
	private Long seq;
    /**
     * 状态，0：正常 1：停用 2：删除
     */
	private String status;
    /**
     * 所属区域
     */
	private String location;
    /**
     * 备注
     */
	private String remark;
    /**
     * 创建人
     */
	@TableField("create_user")
	private String createUser;
    /**
     * 创建日期
     */
	@TableField("create_time")
	private String createTime;
    /**
     * 最后更新人
     */
	@TableField("update_user")
	private String updateUser;
    /**
     * 最后更新日期
     */
	@TableField("update_time")
	private String updateTime;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getSeq() {
		return seq;
	}

	public void setSeq(Long seq) {
		this.seq = seq;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
