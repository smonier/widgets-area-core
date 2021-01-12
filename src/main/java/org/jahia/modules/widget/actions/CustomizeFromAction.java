package org.jahia.modules.widget.actions;/**
 * Created by fabriceaissah on 3/4/16.
 */

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.modules.widget.api.Constants;
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
public class CustomizeFromAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(CustomizeFromAction.class);

    /**
     * This method copies the widget area under to current user node in order to customize it. It also create the
     * appropriate content folders if not already created (/contents/widgets)
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
        JCRNodeWrapper userFolder = session.getUserNode();
        if (!userFolder.hasNode("contents"))
            userFolder.addNode("contents", "jnt:contentFolder");
        userFolder = userFolder.getNode("contents");

        if (!userFolder.hasNode(Constants.WIDGETS_FOLDER_NAME))
            userFolder.addNode(Constants.WIDGETS_FOLDER_NAME, Constants.WIDGETS_FOLDER_PT);
        userFolder = userFolder.getNode(Constants.WIDGETS_FOLDER_NAME);

        JCRNodeWrapper node = session.getNode(resource.getNode().getPath());
        node.copy(userFolder.getPath(), node.getIdentifier());
        //userContentFolder.addNode("widgets","jnt:customWidgetArea");
        session.save();
        return new ActionResult(HttpServletResponse.SC_OK, null, null);
    }

}