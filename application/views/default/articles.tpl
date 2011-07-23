{include file='overall_header.tpl'}
{$plus_this}&nbsp;{$tweet_this}
<br />
{$paginateLinks}
<br />
<br />
<table>
<tr><th>Article ID</th><th>Title</th><th>Author</th><th>Date Posted</th></tr>
{foreach from=$articles key=city_id item="article"}
	<tr><td>{$article->getArticleID()|utf}</td><td><a href="{ci_config name='base_url'}article/view/{$article->getArticleID()}/{$article->getArticleTitleURL()}">{$article->getArticleTitle()|utf}</a></td><td>{$article->getArticleAuthor()|utf}</td><td>{$article->getArticleDateCreated()->format( 'D M jS Y H:i' )}</td></tr>
{/foreach}
</table>
<br />
{$paginateLinks}
{include file='overall_footer.tpl'}