import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/components/circular_progress_about.dart';
import 'package:pokedex_app/models/pokeapiv2.dart';
import 'package:pokedex_app/models/specie.dart';
import 'package:pokedex_app/stores/pokeapi_store.dart';
import 'package:pokedex_app/stores/pokeapiv2_store.dart';

class AbaSobre extends StatelessWidget {
  final PokeApiV2Store _pokeV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokeStore = GetIt.instance<PokeApiStore>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Description:",
              style: TextStyle(
                fontFamily: "Google",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Observer(builder: (_) {
              Specie _specie = _pokeV2Store.specie;
              return SizedBox(
                  height: 60,
                  child: SingleChildScrollView(
                      child: _specie != null
                          ? Text(
                              _specie.flavorTextEntries
                                  .where((item) => item.language.name == 'en')
                                  .first
                                  .flavorText
                                  .replaceAll("\n", " ")
                                  .replaceAll("\f", " ")
                                  .replaceAll("POKéMON", "Pokémon"),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          : CircularProgressAbout()));
            }),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "Biology:",
              style: TextStyle(
                fontFamily: "Google",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: <Widget>[
                  Observer(builder: (_) {
                    return Row(
                      
                      children: <Widget>[
                        Text(
                          "Height: ",
                          style: TextStyle(
                            fontFamily: "Google",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _pokeStore.pokeCurrent.height,
                          style: TextStyle(
                            fontFamily: "Google",
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: 5.0,
                  ),
                  Observer(
                    builder: (_) {
                      return Row(
                       
                        children: <Widget>[
                          Text(
                            "Weight: ",
                            style: TextStyle(
                              fontFamily: "Google",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            _pokeStore.pokeCurrent.weight,
                            style: TextStyle(
                              fontFamily: "Google",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Observer(
              builder: (_) {
                PokeApiV2 pokeV2 = _pokeV2Store.pokeApiV2;
                String firstAbility;
                String lastAbility;
                if (pokeV2 != null) {
                  firstAbility = pokeV2.abilities
                      .where((element) => element.ability != null)
                      .first
                      .ability
                      .name;
                  lastAbility = pokeV2.abilities
                      .where((element) => element.ability != null)
                      .last
                      .ability
                      .name;
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Abilities:",
                      style: TextStyle(
                        fontFamily: "Google",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    (firstAbility != null && pokeV2 != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                firstAbility == lastAbility
                                    ? firstAbility
                                    : firstAbility + ", ",
                                style: TextStyle(
                                  fontFamily: "Google",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                firstAbility == lastAbility ? " " : lastAbility,
                                style: TextStyle(
                                  fontFamily: "Google",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          )
                        : CircularProgressAbout(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
