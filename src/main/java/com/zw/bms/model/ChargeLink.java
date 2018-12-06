package com.zw.bms.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;

/**
 * <p>
 * 计费关联表
 * </p>
 *
 * @author zhaiwei
 * @since 2017-11-18
 */
@TableName("bi_charge_link")
public class ChargeLink extends Model<ChargeLink> {

    private static final long serialVersionUID = 1L;

	@TableId(value="id", type= IdType.AUTO)
	private Long id;
    /**
     * 计费项目id
     */
	@TableField("type_id")
	private Long typeId;
    /**
     * 计费子项id
     */
	@TableField("item_id")
	private Long itemId;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getTypeId() {
		return typeId;
	}

	public void setTypeId(Long typeId) {
		this.typeId = typeId;
	}

	public Long getItemId() {
		return itemId;
	}

	public void setItemId(Long itemId) {
		this.itemId = itemId;
	}

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
