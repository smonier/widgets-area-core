package org.jahia.modules.widget.actions;/**
 * Created by fabriceaissah on 3/4/16.
 */

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRContentUtils;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

public class CreateWidgetAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(CreateWidgetAction.class);

    private static final String PARAM_WIDGET_PATH = "widgetPath";

    /**
     * This method copies the widget located under 'widgetPath' into the customize area located under current user node.
     *
     * @param req
     * @param renderContext
     * @param resource
     * @param session
     * @param parameters
     * @param urlResolver
     * @return
     * @throws Exception
     */
    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        String[] widgetPaths = req.getParameterValues(PARAM_WIDGET_PATH);
        if (widgetPaths != null) {
            for (String widgetPath : widgetPaths) {
                if (widgetPath != null) {
                    JCRNodeWrapper widgetToCreate = session.getNode(widgetPath);
                    JCRNodeWrapper widgetFolder = session.getNode(resource.getNode().getPath());
                    //widgetToCreate.copy(widgetFolder.getPath());
                    widgetToCreate.copy(widgetFolder.getPath(), JCRContentUtils.findAvailableNodeName(widgetFolder, widgetToCreate.getName()));
                }
            }
            session.save();
        }
        return new ActionResult(HttpServletResponse.SC_OK, null, null);
    }
}
