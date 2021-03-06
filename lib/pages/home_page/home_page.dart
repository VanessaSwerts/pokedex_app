import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/consts/consts_app.dart';
import 'package:pokedex_app/models/pokeapi.dart';
import 'package:pokedex_app/pages/home_page/widgets/appbar_home.dart';
import 'package:pokedex_app/pages/home_page/widgets/pokeItem.dart';
import 'package:pokedex_app/pages/poke_detail/poke_detail_page.dart';
import 'package:pokedex_app/stores/pokeapi_store.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore pokeStore;
  MultiTrackTween _animation;

  @override
  void initState() {
    super.initState();
    pokeStore = GetIt.instance<PokeApiStore>();
    if (pokeStore.pokeAPI == null) pokeStore.fetchPokemonList();
    _animation = MultiTrackTween([
      Track("rotation").add(Duration(seconds: 5), Tween(begin: 0.0, end: 6.0),
          curve: Curves.linear)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: -47,
            left: screenWidth - 140,
            child: ControlledAnimation(
                playback: Playback.LOOP,
                duration: _animation.duration,
                tween: _animation,
                builder: (context, animation) {
                  return Transform.rotate(
                    angle: animation['rotation'],
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        ConstsApp.blackPokeball,
                        width: 220,
                        height: 220,
                      ),
                    ),
                  );
                }),
          ),
          SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  AppBarHome(),
                  Expanded(
                    child: Container(
                      child: Observer(builder: (_) {
                        PokeAPI _pokeApi = pokeStore.pokeAPI;
                        return (_pokeApi == null)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AnimationLimiter(
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(12),
                                  addAutomaticKeepAlives: true,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: pokeStore.pokeAPI.pokemon.length,
                                  itemBuilder: (context, index) {
                                    Pokemon pokemon =
                                        pokeStore.getPokemon(index);
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: GestureDetector(
                                          child: PokeItem(
                                            index: index,
                                            name: pokemon.name,
                                            number: pokemon.num,
                                            types: pokemon.type,
                                          ),
                                          onTap: () {
                                            pokeStore.setCurrentPokemon(index);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PokeDetailPage(
                                                  index: index,
                                                ),
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
