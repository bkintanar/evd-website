{include file='overall_header.tpl'}
{$plus_this}&nbsp;{$tweet_this}
{if $article}
<h1>{$article->getArticleTitle()}</h1>
<p><i>by {$article->getArticleAuthor()} on {$article->getArticleDateCreated()->format( 'D M jS Y H:i' )}</i></p>
{$article->getArticleText()|utf}
{/if}
<br />
<br />
{include file='disqus.tpl'}
{include file='overall_footer.tpl'}