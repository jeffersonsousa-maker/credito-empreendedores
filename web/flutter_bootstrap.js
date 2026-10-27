{{flutter_js}}
{{flutter_build_config}}

// Inicialização personalizada: remove a tela de carregamento assim que o
// app desenha o primeiro quadro.
_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    const splash = document.getElementById('splash');
    if (splash) {
      splash.style.opacity = '0';
      setTimeout(function () { splash.remove(); }, 300);
    }
  },
});
