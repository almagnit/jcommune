<%--

    Copyright (C) 2011  JTalks.org Team
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@ taglib prefix="jtalks" uri="http://www.jtalks.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<html>
<head></head>
<body>
<c:set var="authenticated" value="${false}"/>
<h1>JTalks</h1>

<div class="wrap topic_page">
<!-- Начало всех форумов -->
<div class="all_forums">
<h2><a class="heading" href="#"><c:out value="${topic.title}"/></a></h2>

<div class="forum_misc_info">
    &nbsp;
    <span class="nav_top">На страницу: 1, <a href="#">2</a> <a href="#">След.</a></span>
</div>
<div class="forum_top_right_link">
    <a href="#">Предыдущая тема</a> ::
    <a href="#">Следующая тема</a>
</div>
<a class="button top_button" href="${pageContext.request.contextPath}/branches/${branchId}">
    <spring:message code="label.back"/>
</a>
<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
    <a class="button top_button" href="#">Новая тема</a>
    <a class="button top_button"
       href="${pageContext.request.contextPath}/posts/new?topicId=${topicId}">
        <spring:message code="label.answer"/>
    </a>
    <c:set var="authenticated" value="${true}"/>
</sec:authorize>
<c:if test="${authenticated==false}">
    <a class="button top_button disabled" href="#">Новая тема</a>
    <a class="button top_button disabled"
       href="${pageContext.request.contextPath}/posts/new?topicId=${topicId}">
        <spring:message code="label.answer"/>
    </a>
</c:if>
&nbsp; &nbsp; &nbsp;

<jtalks:breadcrumb breadcrumbList="${breadcrumbList}"/>

<!-- Начало группы форумов -->
<div class="forum_header_table"> <!-- Шапка топика -->
    <div class="forum_header">
        <span class="forum_header_userinfo"><spring:message code="label.topic.header.author"/></span>
        <span class="forum_header_topic"><spring:message code="label.topic.header.message"/></span>
    </div>
</div>
<ul class="forum_table"> <!-- Список сообщений -->

    <c:forEach var="post" items="${posts}" varStatus="i">
        <li class="forum_row"> <!-- Сообщение -->
            <div class="forum_userinfo">
                <a class="username"
                   href="${pageContext.request.contextPath}/users/${post.userCreated.encodedUsername}">
                    <c:out value="${post.userCreated.username}"/></a>

                <div class="status">Онлайн</div>

                <c:if test="${post.userCreated.avatar != null}">
                    <%--    <table>
            <tr>
                <td width="100" height="100" align="center" valign="middle">--%>
                    <img src="${pageContext.request.contextPath}/${post.userCreated.encodedUsername}/avatar"
                         alt="Аватар" class="avatar"/>
                    <%-- </td>
                       </tr>
                   </table> --%>
                </c:if>

                <br/>

                <div class="user_misc_info">
                    Зарегистрирован: 13.04.09 <br/>
                    Сообщения: 661 <br/>
                    Откуда: good ol' 60s
                </div>
            </div>
            <div class="forum_message_cell">
                <div class="post_details">
                    <a class="button" href="javascript:copyLink(${post.id})">
                        <spring:message code="label.link"/>
                    </a>
                    <sec:accesscontrollist hasPermission="8,16" domainObject="${post}">
                        <c:choose>
                            <c:when test="${page == 1 && i.index == 0}">
                                <%-- first post - url to delete topic --%>
                                <c:set var="delete_url"
                                       value="${pageContext.request.contextPath}/topics/${topicId}/delete?branchId=${branchId}"/>
                            </c:when>
                            <c:otherwise>
                                <%-- url to delete post --%>
                                <c:set var="delete_url"
                                       value="${pageContext.request.contextPath}/posts/${post.id}/delete?topicId=${topicId}"/>
                            </c:otherwise>
                        </c:choose>
                        <a class="button" href="${delete_url}"><spring:message
                                code="label.delete"/></a>
                    </sec:accesscontrollist>


                    <sec:accesscontrollist hasPermission="8,16" domainObject="${post}">
                        <c:choose>
                            <c:when test="${page == 1 && i.index == 0}">
                                <%-- first post - url to edit topic --%>
                                <c:set var="edit_url"
                                       value="${pageContext.request.contextPath}/topics/${topicId}/edit?branchId=${branchId}"/>
                            </c:when>
                            <c:otherwise>
                                <%-- url to edit post --%>
                                <c:set var="edit_url"
                                       value="${pageContext.request.contextPath}/posts/${post.id}/edit?topicId=${topicId}"/>
                            </c:otherwise>
                        </c:choose>
                        <a class="button" href="${edit_url}"><spring:message
                                code="label.edit"/></a>
                    </sec:accesscontrollist>
                    <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
                        <a class="button" href="#"><spring:message
                                code="label.quotation"/></a>
                    </sec:authorize>
                    <spring:message code="label.added"/>&nbsp;<joda:format value="${post.creationDate}"
                                                                           locale="${sessionScope['org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE']}"
                                                                           pattern="dd MMM yyyy HH:mm"/>
                </div>
                <p class="forum_message_cell_text">
                    <c:out value="${post.postContent}"/>
                    <br/><br/><br/>
                    <c:if test="${post.modificationDate!=null}">
                        <spring:message code="label.modify"/>
                        <joda:format value="${post.modificationDate}"
                                     locale="${sessionScope['org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE']}"
                                     pattern="dd MMM yyyy HH:mm"/>
                    </c:if>
                </p>
                <c:if test="${post.userCreated.signature!=null}">
                    <p class="forum_message_cell_signature">
                        <c:out value="${post.userCreated.signature}"/>
                    </p>
                </c:if>
            </div>
        </li>
    </c:forEach>
</ul>

        <span class="nav_bottom"><spring:message code="label.onPage"/>  <c:if test="${page > 2}">
            <c:url value="/topics/${topicId}" var="first">
                <c:param name="page" value="1"/>
            </c:url>
            <a href='<c:out value="${first}" />' class="pn next"><spring:message code="pagination.first"/></a>...
        </c:if>

            <c:choose>
                <c:when test="${page > 1}">
                    <c:set var="begin" value="${page - 1}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="begin" value="1"/>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${page + 1 < maxPages}">
                    <c:set var="end" value="${page + 1}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="end" value="${maxPages}"/>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="${begin}" end="${end}" step="1" varStatus="i">
                <c:choose>
                    <c:when test="${page == i.index}">
                        <span>${i.index}</span>
                    </c:when>
                    <c:otherwise>
                        <c:url value="/topics/${topicId}" var="url">
                            <c:param name="page" value="${i.index}"/>
                        </c:url>
                        <a href='<c:out value="${url}" />'>${i.index}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${page + 2 < maxPages+1}">
                <c:url value="/topics/${topicId}" var="last">
                    <c:param name="page" value="${maxPages}"/>
                </c:url>
                ...<a href='<c:out value="${last}"/>' class="pn next"><spring:message code="pagination.last"/></a>
            </c:if></span>
<a class="button" href="${pageContext.request.contextPath}/branches/${branchId}">
    <spring:message code="label.back"/>
</a>
<sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
    <a class="button" href="#">Новая тема</a>
    <a class="button"
       href="${pageContext.request.contextPath}/posts/new?topicId=${topicId}">
        <spring:message code="label.answer"/>
    </a>
</sec:authorize>
<c:if test="${authenticated==false}">
    <a class="button disabled" href="#">Новая тема</a>
    <a class="button disabled"
       href="${pageContext.request.contextPath}/posts/new?topicId=${topicId}">
        <spring:message code="label.answer"/>
    </a>
</c:if>
&nbsp; &nbsp; &nbsp;

<jtalks:breadcrumb breadcrumbList="${breadcrumbList}"/>

<div class="forum_misc_info">
    <spring:message code="label.page"/> <c:out value="${page}"/> <spring:message code="label.of"/> <c:out
        value="${maxPages}"/>
    <br/>
    Модераторы:
    <ul class="users_list">
        <li><a href="#">andreyko</a>,</li>
        <li><a href="#">Староверъ</a>,</li>
        <li><a href="#">Вася</a>.</li>
    </ul>
    <br/>
    Сейчас эту тему просматривают: Нет
</div>
</div>
<!-- Конец всех форумов -->
<div class="footer_buffer"></div>
<!-- Несемантичный буфер для прибития подвала -->
</div>


<!-- content -->
<script type="text/javascript">
    function copyLink(postId) {
        prompt("Link to copy", document.location.href + "#" + postId);
    }
</script>
</body>
</html>