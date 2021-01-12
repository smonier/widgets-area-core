<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="bootstrap.min.css" />
<jcr:node var="widgetsAvailable" path="${renderContext.site.path}/availableWidgets"/>
<template:addCacheDependency node="${widgetsAvailable}"/>
<!-- Trigger the modal with a button -->
<button type="button" data-toggle="modal" data-placement="top" data-delay="300" title="" class="btn btn-default btn-u" data-target="#widgetCreation${currentNode.identifier}"><fmt:message key="widgetarea.add.widget.button"/></button>
<button class="btn btn-default btn-u" type="button" onclick="$('#reset${currentNode.identifier}').submit()"><fmt:message key="widgetarea.reset.area.button"/></button>

<!-- Modal -->
<div class="modal fade" id="widgetCreation${currentNode.identifier}" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><fmt:message key="widgetarea.creation"/></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form class="widget-form" action="<c:url value='${url.base}${currentNode.path}.createWidget.do'/>" method="post">
                    <input name="jcrRedirectTo" value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>" type="hidden"/>
                    <c:forEach items="${jcr:getChildrenOfType(widgetsAvailable, 'jmix:widget')}" var="widget">
                        <template:addCacheDependency node="${widget}"/>
                        <div class="col-lg-offset-3 col-lg-9 text-left">
                            <div class="radio">
                                <label>
                                    <input type="checkbox" name="widgetPath" value="${widget.path}"/>
                                        ${widget.displayableName}
                                </label>
                            </div>
                        </div>
                    </c:forEach>
                    <button class="btn btn-default btn-u widgetCreateButton" type="submit" disabled><fmt:message key="widgetarea.create.button"/></button>
                </form>
            </div>
        </div>
    </div>
</div>

<template:tokenizedForm>
    <form id="reset${currentNode.identifier}" action="<c:url value='${url.base}${currentNode.path}.resetWidgetArea.do'/>" method="post">
        <input name="jcrRedirectTo" value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>" type="hidden"/>
    </form>
</template:tokenizedForm>

