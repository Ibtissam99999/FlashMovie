import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final ApiService apiService = ApiService();
  List<dynamic> actors = [];
  late Future<bool> isFavoriteFuture;
  bool isFavorite = false;  // Déclarer la variable isFavorite

  @override
  void initState() {
    super.initState();
    // Charger les acteurs associés au film
    apiService.fetchActors(widget.movie.id).then((data) {
      setState(() {
        actors = data;
      });
    });
    // Vérifier si le film est dans les favoris
    isFavoriteFuture = DBService.isFavorite(widget.movie.id);
  }

  void _toggleFavorite() async {
    final currentFav = await DBService.isFavorite(widget.movie.id);

    if (currentFav) {
      await DBService.removeFavorite(widget.movie.id);
    } else {
      await DBService.addFavorite(widget.movie);
    }

    setState(() {
      isFavoriteFuture = DBService.isFavorite(widget.movie.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentFav ? 'Retiré des favoris' : 'Ajouté aux favoris'),
        duration: const Duration(seconds: 1),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final double percent = (movie.voteAverage / 10).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: percent,
                          center: Text(
                            '${(percent * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          progressColor: Colors.greenAccent,
                          backgroundColor: Colors.grey.shade800,
                          animation: true,
                          animationDuration: 800,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Sortie : ${movie.releaseDate}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.overview,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Acteurs principaux",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: actors.length > 10 ? 10 : actors.length,
                    itemBuilder: (context, index) {
                      final actor = actors[index];
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                actor['profile_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w200${actor['profile_path']}'
                                    : 'https://via.placeholder.com/100',
                              ),
                              radius: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              actor['name'],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FutureBuilder<bool>(
              future: isFavoriteFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else {
                  bool isFavorite = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white12,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
