{ci_language file="subject"}
{include file='overall_header.tpl'}
{$plus_this}{$tweet_this}
{if isset($has_prospectus)}
<table>
{foreach from=$subject_array key=year_semester item="subjects"}
    <tr><th>{ci_language line="year"} {$year_semester}<br />{ci_language line="subject_code"}</th><th>{ci_language line="subject_title"}</th><th>{ci_language line="units"}</th><th>{ci_language line="cut_off"}</th><th>{ci_language line="prerequisites"}</th></tr>
    {assign var=total_units value=""}
    {foreach from=$subjects item="subject"}
        <tr>
            <td>{if $subject->getSubjectType() == 'major'}<b>{/if}{$subject->getSubjectInfo()->getSubjectInfoCode()}{if $subject->getSubjectType() == 'major'}</b>{/if}</td>
            <td>{if $subject->getSubjectType() == 'major'}<b>{/if}{$subject->getSubjectInfo()->getSubjectInfoName()}{if $subject->getSubjectType() == 'major'}</b>{/if}</td>
            <td align="center">{if $subject->getSubjectType() == 'major'}<b>{/if}{$subject->getSubjectInfo()->getSubjectInfoUnit()}{if $subject->getSubjectType() == 'major'}</b>{/if}</td>
            <td align="center">{if $subject->getSubjectType() == 'major'}<b>{/if}{$subject->getSubjectCutOff()}{if $subject->getSubjectType() == 'major'}</b>{/if}</td>
            <td></td>
        </tr>
        {assign var=total_units value=$total_units+$subject->getSubjectInfo()->getSubjectInfoUnit()}
    {/foreach}
    <tr><td></td><td align="right">Total Units</td><td align="center">{$total_units}</td><td></td></tr>
{/foreach}
</table>
{/if}
{include file='overall_footer.tpl'}