package org.jahia.modules.widget.actions;/**
 * Created by fabriceaissah on 3/4/16.
 */

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.modules.widget.api.Constants;
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

public class MoveWidgetAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(MoveWidgetAction.class);

    public static final String PARAM_OLD_IDX = "oldIndex";
    public static final String PARAM_NEW_IDX = "newIndex";

    /**
     * This method reorganize the widgets after a drag and drop. It uses the 2 parameters 'oldIndex' and 'newIndex'
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
        JCRNodeWrapper node = session.getNode(resource.getNode().getPath());
        int oldIndex = Integer.parseInt(req.getParameter(PARAM_OLD_IDX));
        int newIndex = Integer.parseInt(req.getParameter(PARAM_NEW_IDX));
        newIndex = oldIndex > newIndex ? newIndex : newIndex + 1;
        List<JCRNodeWrapper> widgets = JCRContentUtils.getChildrenOfType(node, Constants.WIDGETS_MIXIN);
        JCRNodeWrapper SourceNode = widgets.get(oldIndex);
        if (widgets.size() > newIndex) {
            JCRNodeWrapper TargetNode = widgets.get(newIndex);
            node.orderBefore(SourceNode.getName(), TargetNode.getName());
        } else {
            node.orderBefore(SourceNode.getName(), null);
        }
        session.save();
        return new ActionResult(HttpServletResponse.SC_OK, null, null);
    }
}