import 'package:flutter/material.dart';

class TweetScreen extends StatelessWidget {
  const TweetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile and Tweet Header
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://example.com/profile_image.jpg'), // Ganti dengan URL gambar profil
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Username', // Nama pengguna
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '@username • 1h', // Nama pengguna dan waktu posting
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tweet Content
            const Text(
              'This is an example of a tweet. It can include text, hashtags, mentions, and more!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Actions (Like, Retweet, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TweetScreen(),
  ));
}
