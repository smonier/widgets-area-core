window.jahia.i18n.loadNamespaces('widgets-area-core');

window.jahia.uiExtender.registry.add('adminRoute', 'widgets-area-core', {
    targets: ['jcontent:100'],
    icon: window.jahia.moonstone.toIconComponent('Widgets'),
    label: 'widgets-area-core:label.title',
    isSelectable: true,
    requiredPermission: 'siteAdminWidgetsAdmin',
    requireModuleInstalledOnSite: 'widgets-area-core',
    iframeUrl: window.contextJsParameters.contextPath + '/cms/editframe/default/$lang/sites/$site-key.widgetsAdmin.html'
});


