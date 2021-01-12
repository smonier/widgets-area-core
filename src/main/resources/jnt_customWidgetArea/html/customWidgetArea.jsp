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
<template:addResources type="javascript" resources="jquery.js"/>
<template:addResources type="javascript" resources="jquery-ui.js"/>
<template:addResources type="css" resources="jquery-ui.min.css"/>
<template:addResources type="css" resources="widgetArea.css"/>

<jcr:node var="userNode" path="${currentUser.localPath}" />
    <jcr:node var="userContentNode" path="${currentUser.localPath}/contents" />
<jcr:node var="userCustomWidgets" path="${currentUser.localPath}/contents/widgets/${currentNode.identifier}"/>
<jcr:node var="widgetFolder" path="${currentUser.localPath}/contents/widgets"/>

<c:choose>
    <c:when test="${userCustomWidgets == null || renderContext.editMode}">
        <%-- We display the default area --%>
        <template:addCacheDependency node="${userNode}"/>
        <template:addCacheDependency node="${widgetFolder}"/>
        <template:addCacheDependency node="${userContentNode}"/>
        <div class="widgetarea-container">
            <div class="widgetArea">
                <ul class="sortable" id="sortableWidgetArea-${currentNode.identifier}"><%-- TODO how about if I use twice the component in the same page? I will have twice id="sortableWidgetArea" --%>
                    <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jmix:widget')}" var="widget">
                        <li><template:module node="${widget}" view="detailview"/></li>
                    </c:forEach>
                </ul>
                <c:choose>
                    <c:when test="${renderContext.editMode}">
                        <template:module path="*"/>
                    </c:when>
                    <c:when test="${renderContext.loggedIn && renderContext.liveMode}">
                        <%-- We display the customize button --%>
                        <template:tokenizedForm>
                            <div class="text-center">
                                <form id="form-${currentNode.identifier}" action="<c:url value='${url.base}${currentNode.path}'/>.customizeWidgetArea.do" method="post">
                                    <input name="jcrRedirectTo" value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>" type="hidden"/>
                                    <button class="btn btn-primary" type="submit"><fmt:message key="widgetarea.customize.area.button"/></button>
                                </form>
                            </div>
                        </template:tokenizedForm>
                    </c:when>
                    <c:otherwise>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="clear"></div>
    </c:when>
    <c:otherwise>
        <%-- We display the customzed area --%>
        <template:addCacheDependency node="${userCustomWidgets}"/>
        <template:module path="${userCustomWidgets.path}" view="custom"/>
    </c:otherwise>
</c:choose>