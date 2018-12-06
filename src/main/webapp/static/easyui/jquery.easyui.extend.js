//自定义DataGrid的Editor编辑器——按钮
$.extend($.fn.datagrid.defaults.editors, {  
    userSaveButton : {  
    init: function(container, options){  
        var button = $("<a href='javascript:void(0)'></a>").linkbutton({plain:true, iconCls:"icon-save"});  
        button.appendTo(container);
        return button;  
    },  
    getValue: function(target)  
    {  
        return $(target).text();  
    },  
    setValue: function(target, value)  
    {  
        $(target).text(value);  
    },  
    resize: function(target, width)  
    {  
        var span = $(target);  
        if ($.boxModel == true){  
            span.width(width - (span.outerWidth() - span.width()) - 10);  
        } else {  
            span.width(width - 10);  
        }  
    }  
    }  
});  