{ci_language file="subject"}
{include file='overall_header.tpl'}
{$plus_this}&nbsp;{$tweet_this}
<br />
{foreach from=$cities key=city_id item="city"}
	{$city->getState()->getStateName()}&nbsp;&nbsp;&nbsp;&nbsp;{$city->getCityName()|utf}<br />
{/foreach}
{$paginateLinks}
{include file='overall_footer.tpl'}