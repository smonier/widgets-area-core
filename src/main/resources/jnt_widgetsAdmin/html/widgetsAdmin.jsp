<%@ page import="org.jahia.services.SpringContextSingleton" %>
<%@ page import="org.jahia.services.templates.JahiaTemplateManagerService" %>
<%@ page import="org.jahia.bin.SessionNamedDataStorage" %>
<%@ taglib uri="http://www.jahia.org/tags/templateLib" prefix="template" %>
<%@ taglib prefix="internal" uri="http://www.jahia.org/tags/internalLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="widget" uri="http://www.jahia.org/tags/widget" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="datatables/css/bootstrap-theme.css"/>
<template:addResources type="css" resources="typeahead.css"/>
<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="jquery-ui.min.js,jquery.blockUI.js"/>
<template:addResources type="javascript" resources="datatables/jquery.dataTables.min.js,datatables/dataTables.bootstrap-ext.js,i18n/jquery.dataTables-${currentResource.locale}.js,datatables/dataTables.i18n-sorting-ext.js,settings/dataTables.initializer.js"/>
<template:addResources type="javascript" resources="bootbox.min.js"/>
<template:addResources type="javascript" resources="underscore.min.js"/>
<template:addResources type="javascript" resources="typeahead.min.js"/>
<template:addResources type="javascript" resources="widgetsadmin.js"/>

<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>
<jcr:node var="widgetsAvailable" path="${renderContext.site.path}/availableWidgets"/>
<fmt:message key="label.cancel" var="labelCancel"/>
<fmt:message key="label.ok" var="labelOk"/>
<fmt:message key="widgetarea.remove" var="labelDelete"/>
<fmt:message key="widgetarea.modal.delete.text" var="modalDeleteAll"/>
<fmt:message key="label.workInProgressTitle" var="i18nWaiting"/>

<script>
    var jsVarMap = {
        labelCancel: '${functions:escapeJavaScript(labelCancel)}',
        labelOk: '${functions:escapeJavaScript(labelOk)}',
        labelRename: '${functions:escapeJavaScript(labelRename)}',
        labelDelete: '${functions:escapeJavaScript(labelDelete)}',
        i18nWaiting: '${functions:escapeJavaScript(i18nWaiting)}',
        labelTagNewName: '${functions:escapeJavaScript(labelTagNewName)}',
        modalRenameAll: '${functions:escapeJavaScript(modalRenameAll)}',
        modalDeleteAll: '${functions:escapeJavaScript(modalDeleteAll)}'
    };

    $(document).ready(function () {
        var dtOptions = {
            "aoColumns": [ //accent sorting for col 1, disable search for col 2 and 3
                {targets: 0, type: 'diacritics-neutralise'},
                {"bSearchable": false},
                {"bSearchable": false}
            ]
        };
        attachDeleteListeners();
        dataTablesSettings.init('tableWidgetsList', 25, null, null, null, dtOptions);
        attachDeleteListeners();
    });
</script>
<div class="page-header">
    <h2 class="edit"><fmt:message key="label.widgetsAdministration"/> - ${fn:escapeXml(site.displayableName)}</h2>
</div>
<c:if test="${not widgetsAvailable.isNodeType('jnt:contentList')}">
    Create Directory
</c:if>
<jcr:jqom var="widgetsList">
    <query:selector nodeTypeName="jmix:widget"/>
    <query:descendantNode path="${widgetsAvailable.path}"/>
</jcr:jqom>
<div class="panel panel-default">
    <div class="panel-heading">
        <button type="button" class="btn btn-default btn-raised pull-right" id="addwidget">
            <fmt:message key="widgetarea.add.widget.button"/>
        </button>
    </div>

    <div class="panel-body">
        <div class="row">
            <div class="col-md-12">
                <table class="table table-bordered table-striped" id="tableWidgetsList">
                    <thead>
                    <tr>
                        <th>
                            <fmt:message key="widgetarea.widgetName"/>
                        </th>
                        <th width="20%">
                            <fmt:message key="widgetarea.widgetType"/>
                        </th>
                        <th width="20%">
                            <fmt:message key="label.status"/>
                        </th>
                        <th width="15%">
                            <fmt:message key="label.actions"/>
                        </th>

                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${widgetsList.nodes}" var="objects" varStatus="status">
                        <tr>
                            <td>
                                    ${objects.displayableName} (${objects.name})
                            </td>
                            <td>
                                    ${objects.primaryNodeTypeName}
                            </td>
                            <td>
                                <button type="button" class="btn"
                                        onclick="window.top.CE_API.edit('${objects.UUID}','${site.name}','${widgetsAvailable.language}','${widgetsAvailable.language}')">
                                        ${widget:getPubStatus(objects,widgetsAvailable.language)}
                                </button>
                            </td>
                            <td>
                                <button type="button" class="btn btn-fab btn-fab-xs btn-default editWidgetButton"
                                        data-title="<fmt:message key='widgetarea.edit'/>"
                                        onclick="window.top.CE_API.edit('${objects.UUID}','${site.name}','${widgetsAvailable.language}','${widgetsAvailable.language}')">
                                    <i class="material-icons">edit</i>
                                </button>
                                <button type="button" class="btn btn-fab btn-fab-xs btn-danger deleteWidgetButton"
                                        data-toggle="tooltip" data-container="body"
                                        data-sel-role="delete_Widget"
                                        data-title="<fmt:message key='widgetarea.delete'/>"
                                        id="delete_${objects.name}">
                                    <i class="material-icons">delete</i>
                                </button>
                                <template:tokenizedForm>
                                    <form action="<c:url value='${objects.path}'/>"
                                          method="post" id="widgetsAdmin-delete-${objects.name}">
                                        <input type="hidden" name="jcrRedirectTo"
                                               value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>"/>
                                        <input type="hidden" name="jcrNewNodeOutputFormat" value=""/>
                                        <input type="hidden" name="jcrMethodToCall" value="delete"/>
                                    </form>
                                </template:tokenizedForm>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script>
    $(document).ready(function () {
        $('#addwidget').click(function () {
            window.top.CE_API.create('${widgetsAvailable.UUID}', '${widgetsAvailable.path}', '${site.name}', '${widgetsAvailable.language}', '${widgetsAvailable.language}', ['jmix:widget'], [], true);
        })
    })
</script>
