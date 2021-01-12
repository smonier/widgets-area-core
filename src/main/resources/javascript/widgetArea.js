function deleteWidget(widgetUUID){
    var form = $("#delete-widget-"+widgetUUID);
    $.post(form.attr('action'), form.serialize())
    $("#widget-"+widgetUUID).fadeOut( "slow" );
}

function initWidgetArea(areaId,actionPath){
    $('#sortableWidgetArea'+areaId).sortable({
        start: function(e, ui) {
            // creates a temporary attribute on the element with the old index
            $(this).attr('data-previndex', ui.item.index());
        },
        update: function(e, ui) {
            // gets the new and old index then removes the temporary attribute
            var newIndex = ui.item.index();
            var oldIndex = $(this).attr('data-previndex');
            $(this).removeAttr('data-previndex');
            moveWidget(oldIndex,newIndex,actionPath);
        },
        handle: ".handle"
    });

    function moveWidget(oldIndex,newIndex,actionPath){
        $.ajax({
            type: "POST",
            url: actionPath,
            data: {
                "oldIndex": oldIndex,
                "newIndex": newIndex
            },
            success: function (data) {
            }
        });
    }
}

$(document).ready(function() {
    $('input[name="widgetPath"]').change(function(){
        if($('input[name="widgetPath"]:checked').length){
            $(this).closest(".widget-form").find( ".widgetCreateButton" ).prop('disabled', false);
        }else{
            $(this).closest(".widget-form").find( ".widgetCreateButton" ).prop('disabled', false);
        }
    });

    // .modal-backdrop classes
    $(".modal-fullscreen").on('show.bs.modal', function () {
        setTimeout( function() {
            $(".modal-backdrop").addClass("modal-backdrop-fullscreen");
        }, 0);
    });
    $(".modal-fullscreen").on('hidden.bs.modal', function () {
        $(".modal-backdrop").addClass("modal-backdrop-fullscreen");
    });
});


