package org.jahia.modules.widget.actions;/**
 * Created by fabriceaissah on 3/4/16.
 */

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
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

public class ResetWidgetAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(ResetWidgetAction.class);

    /**
     * This method deletes the custom wigdet area in the current user node in order to go back the default website widget area.
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
        JCRNodeWrapper customWidgetArea = session.getNode(resource.getNode().getPath());
        customWidgetArea.remove();
        session.save();
        return new ActionResult(HttpServletResponse.SC_OK, null, null);
    }
}