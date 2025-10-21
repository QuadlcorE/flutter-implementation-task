import 'package:flutter_implementation_task/common_libs.dart';
import 'package:flutter_implementation_task/services/news_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsLogic _newsLogic = GetIt.I.get<NewsLogic>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch news on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_newsLogic.articles.isEmpty) {
        _newsLogic.fetchTopHeadlines();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: $styles.colors.primary,
      appBar: AppBar(
        title: Text('News', style: $styles.text.h2),
        backgroundColor: $styles.colors.primary,
        foregroundColor: $styles.colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all($styles.insets.md),
            color: $styles.colors.primary,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _newsLogic.fetchTopHeadlines();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular($styles.corners.md),
                ),
                filled: true,
                fillColor: $styles.colors.white,
              ),
              onSubmitted: (query) {
                _newsLogic.searchNews(query);
              },
            ),
          ),

          // Category chips
          ListenableBuilder(
            listenable: _newsLogic,
            builder: (context, _) {
              return Container(
                height: 50,
                padding: EdgeInsets.symmetric(vertical: $styles.insets.xs),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                  itemCount: _newsLogic.categories.length,
                  itemBuilder: (context, index) {
                    final category = _newsLogic.categories[index];
                    final isSelected = category == _newsLogic.selectedCategory;

                    return Padding(
                      padding: EdgeInsets.only(right: $styles.insets.sm),
                      child: ChoiceChip(
                        label: Text(
                          category[0].toUpperCase() + category.substring(1),
                          style: $styles.text.bodySmall.copyWith(
                            color: isSelected
                                ? $styles.colors.white
                                : $styles.colors.greyMedium,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _newsLogic.changeCategory(category);
                          }
                        },
                        selectedColor: $styles.colors.primary,
                        backgroundColor: $styles.colors.greyMedium,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // News list
          Expanded(
            child: ListenableBuilder(
              listenable: _newsLogic,
              builder: (context, _) {
                // Loading state
                if (_newsLogic.isLoading && _newsLogic.articles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: $styles.colors.primary,
                        ),
                        SizedBox(height: $styles.insets.md),
                        Text(
                          'Loading news...',
                          style: $styles.text.body.copyWith(
                            color: $styles.colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Error state
                if (_newsLogic.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all($styles.insets.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: $styles.colors.error,
                          ),
                          SizedBox(height: $styles.insets.md),
                          Text(
                            _newsLogic.errorMessage!,
                            style: $styles.text.body,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: $styles.insets.lg),
                          ElevatedButton(
                            onPressed: () => _newsLogic.fetchTopHeadlines(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: $styles.colors.primary,
                              foregroundColor: $styles.colors.white,
                            ),
                            child: Text('Retry', style: $styles.text.button),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty state
                if (_newsLogic.articles.isEmpty) {
                  return Center(
                    child: Text(
                      'No news articles found',
                      style: $styles.text.body.copyWith(
                        color: $styles.colors.white,
                      ),
                    ),
                  );
                }

                // News list
                return RefreshIndicator(
                  onRefresh: () => _newsLogic.refresh(),
                  color: $styles.colors.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.all($styles.insets.md),
                    itemCount: _newsLogic.articles.length,
                    itemBuilder: (context, index) {
                      final article = _newsLogic.articles[index];
                      return _NewsArticleCard(
                        article: article,
                        onTap: () => _launchUrl(article.url),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsArticleCard extends StatelessWidget {
  const _NewsArticleCard({required this.article, required this.onTap});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: $styles.insets.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular($styles.corners.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular($styles.corners.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular($styles.corners.lg),
                  topRight: Radius.circular($styles.corners.lg),
                ),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: $styles.colors.greyMedium,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: $styles.colors.greyMedium,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all($styles.insets.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and time
                  Row(
                    children: [
                      if (article.sourceName != null) ...[
                        Icon(
                          Icons.article_outlined,
                          size: 14,
                          color: $styles.colors.primary,
                        ),
                        SizedBox(width: $styles.insets.xxs),
                        Text(
                          article.sourceName!,
                          style: $styles.text.caption.copyWith(
                            color: $styles.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: $styles.insets.sm),
                      ],
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: $styles.colors.white,
                      ),
                      SizedBox(width: $styles.insets.xxs),
                      Text(
                        timeago.format(article.publishedAt),
                        style: $styles.text.caption.copyWith(
                          color: $styles.colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: $styles.insets.sm),

                  // Title
                  Text(
                    article.title,
                    style: $styles.text.h3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Description
                  if (article.description != null) ...[
                    SizedBox(height: $styles.insets.sm),
                    Text(
                      article.description!,
                      style: $styles.text.bodySmall.copyWith(
                        color: $styles.colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Author
                  if (article.author != null) ...[
                    SizedBox(height: $styles.insets.sm),
                    Text(
                      'By ${article.author}',
                      style: $styles.text.caption.copyWith(
                        color: $styles.colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  SizedBox(height: $styles.insets.sm),

                  // Read more button
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        'Read more',
                        style: $styles.text.bodySmall.copyWith(
                          color: $styles.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: $styles.insets.xxs),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: $styles.colors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
