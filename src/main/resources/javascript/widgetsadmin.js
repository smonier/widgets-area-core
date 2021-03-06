
function callWorkInProgress(){
    if($.browser.msie == true){
        $.blockUI({ css: {
                border: 'none',
                padding: '15px',
                backgroundColor: '#000',
                '-webkit-border-radius': '10px',
                '-moz-border-radius': '10px',
                opacity: .5,
                color: '#fff'
            }, message: jsVarMap.i18nWaiting });
    } else {
        workInProgress(jsVarMap.i18nWaiting);
    }
}

function bbDeleteWidget(widgetUUID) {
    widgetUUID = JSON.parse('"' + widgetUUID + '"');
    bootbox.dialog({
        title: "<h4>" + jsVarMap.labelDelete + " : " + widgetUUID + "</h4>",
        message: "<p>" + jsVarMap.modalDeleteAll + "</p>",
        buttons: {
            danger: {
                label: jsVarMap.labelCancel,
                className: "btn-default",
                callback: function() {}
            },
            success: {
                label: jsVarMap.labelDelete,
                className: "btn-danger btn-raised",
                callback: function() {
                   // callWorkInProgress();
                    $("#widgetsAdmin-delete-"+widgetUUID).submit();
                }
            }
        }
    });
}

function attachDeleteListeners() {
    var deleteButtons = document.getElementsByClassName("deleteWidgetButton");
    for (var i = 0; i < deleteButtons.length; i++) {
        deleteButtons[i].addEventListener("click", function(e) {
            bbDeleteWidget(e.currentTarget.id.replace("delete_", ""));
        });
    }
}
