package org.jahia.modules.widget.taglibs;

import org.apache.commons.lang.StringUtils;
import org.jahia.api.Constants;
import org.jahia.osgi.BundleUtils;
import org.jahia.services.content.*;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.RenderService;
import org.jahia.services.render.TemplateNotFoundException;
import org.jahia.services.render.scripting.Script;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.security.SecureRandom;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Functions {

    private static final Logger logger = LoggerFactory.getLogger(Functions.class);
    private static ComplexPublicationService publicationService;

    public static final int PUBLISHED = 1;
    public static final int MODIFIED = 3;
    public static final int NOT_PUBLISHED = 4;
    public static final int UNPUBLISHED = 5;
    public static final int MANDATORY_LANGUAGE_UNPUBLISHABLE = 6;
    public static final int LIVE_MODIFIED = 7;
    public static final int LIVE_ONLY = 8;
    public static final int CONFLICT = 9;
    public static final int MANDATORY_LANGUAGE_VALID = 10;
    public static final int DELETED = 11;
    public static final int MARKED_FOR_DELETION = 12;

    private static final Map<Integer, String> statusToLabel = new HashMap<>();

    static {
        statusToLabel.put(PublicationInfo.PUBLISHED, "published");
        statusToLabel.put(PublicationInfo.MARKED_FOR_DELETION, "marked for deletion");
        statusToLabel.put(PublicationInfo.MODIFIED, "modified");
        statusToLabel.put(PublicationInfo.NOT_PUBLISHED, "not published");
        statusToLabel.put(PublicationInfo.UNPUBLISHED, "unpublished");
        statusToLabel.put(PublicationInfo.MANDATORY_LANGUAGE_UNPUBLISHABLE, "mandatory language unpublishable");
        statusToLabel.put(PublicationInfo.LIVE_MODIFIED, "live modified");
        statusToLabel.put(PublicationInfo.LIVE_ONLY, "live only");
        statusToLabel.put(PublicationInfo.CONFLICT, "conflict");
        statusToLabel.put(PublicationInfo.MANDATORY_LANGUAGE_VALID, "mandatory language valid");
        statusToLabel.put(PublicationInfo.DELETED, "deleted");
    }

    public static String getLabel(Integer status) {
        return statusToLabel.get(status);
    }

    public static Boolean hasNoDefaultScriptView(JCRNodeWrapper node, String viewName, RenderContext renderContext) {
        try {
            Script script = RenderService.getInstance().resolveScript(new org.jahia.services.render.Resource(node, renderContext.getMainResource().getTemplateType(), viewName, renderContext.getMainResource().getContextConfiguration()), renderContext);
            if (script != null) {
                return script.getView().getKey() != "default";
            }
        } catch (TemplateNotFoundException e) {
            //Do nothing
        } catch (RepositoryException e) {
            //Do nothing
        }
        return false;
    }

    public static String getPubStatus(JCRNodeWrapper myNode, String language) throws RepositoryException {
        logger.info("node: " + myNode.getIdentifier() + " - lang: " + language);
        publicationService = BundleUtils.getOsgiService(ComplexPublicationService.class, null);

        try {
            ComplexPublicationService.AggregatedPublicationInfo infoNotUsingSubNodes = publicationService.getAggregatedPublicationInfo(myNode.getIdentifier(), language, false, false, getSession());
            return getLabel(infoNotUsingSubNodes.getPublicationStatus());
        } catch (RepositoryException e) {
            logger.error(e.getMessage());
            return null;
        }
    }


    static final String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    static SecureRandom rnd = new SecureRandom();

    public static String randomString(int len) {
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++)
            sb.append(AB.charAt(rnd.nextInt(AB.length())));
        return sb.toString();
    }

    private static JCRSessionWrapper getSession() throws RepositoryException {
        return JCRSessionFactory.getInstance().getCurrentUserSession();
    }
}