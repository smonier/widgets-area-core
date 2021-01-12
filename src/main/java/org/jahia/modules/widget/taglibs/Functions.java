package org.jahia.modules.widget.taglibs;

import org.jahia.services.content.*;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.RenderService;
import org.jahia.services.render.TemplateNotFoundException;
import org.jahia.services.render.scripting.Script;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.util.Collections;
import java.util.Set;

public class Functions {

    private static final Logger logger = LoggerFactory.getLogger(Functions.class);


    public static Boolean hasNoDefaultScriptView(JCRNodeWrapper node, String viewName, RenderContext renderContext) {
        try {
            Script script = RenderService.getInstance().resolveScript(new org.jahia.services.render.Resource(node, renderContext.getMainResource().getTemplateType(), viewName, renderContext.getMainResource().getContextConfiguration()), renderContext);
            if (script != null){
                return script.getView().getKey() !="default";
            }
        } catch (TemplateNotFoundException e) {
            //Do nothing
        } catch (RepositoryException e) {
            //Do nothing
        }
        return false;
    }

    public static int getVisibilityStatus(JCRNodeWrapper NodeWrapper, JCRSessionWrapper destinationSession, String languages, String uuid) throws RepositoryException {
        return JCRPublicationService.getInstance().getStatus(NodeWrapper, destinationSession, Collections.singleton(languages), Collections.singleton(uuid))   ;
    }

}