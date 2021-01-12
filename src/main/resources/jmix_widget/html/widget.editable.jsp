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
<%@ taglib prefix="widget" uri="http://www.jahia.org/tags/widget" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<div class="panel panel-grey margin-bottom-10">

    <div class="panel-heading d-flex justify-content-between">
        <div><h5 class="panel-title text-left">${currentNode.displayableName}</h5></div>
        <div class="text-right"><a href="javascript:void(0)"><i class="fa fa-remove pull-right"
                                                                onclick="deleteWidget('${currentNode.identifier}');return false;"
                                                                data-toggle="tooltip" data-placement="top"
                                                                data-delay="400" title=""
                                                                data-original-title="Delete this widget"></i></a>
            <c:if test="${widget:hasNoDefaultScriptView(currentNode, 'full' , renderContext)}">
                <a href="javascript:void(0)"><i class="fa fa-expand pull-right full" data-toggle="modal"
                                                data-placement="top" data-target="#fullWidget${currentNode.identifier}"
                                                data-delay="400" title="" data-original-title="Expand this widget"></i></a>
            </c:if>
            <c:if test="${widget:hasNoDefaultScriptView(currentNode, 'edit' , renderContext)}">
                <a href="javascript:void(0)"><i class="fa fa-cog pull-right setting" data-toggle="modal"
                                                data-placement="top" data-target="#editWidget${currentNode.identifier}"
                                                data-delay="400" title=""
                                                data-original-title="Configure this widget"></i></a>
            </c:if>
            <a href="javascript:void(0)"><i class="fa fa-arrows pull-right handle" data-toggle="tooltip"
                                            data-placement="top" data-delay="400" title="" aria-hidden="true"
                                            data-original-title="Move this widget"></i></a>

        </div>
    </div>
    <div class="panel-body widget-content">
        <template:include view="detail"/>
    </div>

    <template:tokenizedForm>
    <form action="<c:url value='${url.base}${currentNode.path}'/>" method="post"
          id="delete-widget-${currentNode.identifier}">
        <input type="hidden" name="jcrRedirectTo"
               value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>"/>
            <%-- Define the output format for the newly created node by default html or by redirectTo--%>
        <input type="hidden" name="jcrNewNodeOutputFormat" value="html"/>
        <input type="hidden" name="jcrMethodToCall" value="delete"/>
    </form>
    </template:tokenizedForm>


    <!-- Modal Edit -->
    <div class="modal fade" id="editWidget${currentNode.identifier}" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><fmt:message key="widgetarea.edit"/>&nbsp${currentNode.displayableName}</h4>
                </div>
                <div class="modal-body">
                    <template:include view="edit"/>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal Full -->
    <div class="modal fade modal-fullscreen" id="fullWidget${currentNode.identifier}" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content text-center">
                <div class="modal-body">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <template:include view="full"/>
                </div>
            </div>

        </div>
    </div>

