<%@ include file="common/header.jspf"%>
<%@ include file="common/navigation.jspf"%>

<div class="container">
    <h2>Error Occurred</h2>
    <p>Sorry, something went wrong. Please contact support if you experience any issues!</p>
    
    <h4>Error Details</h4>
    <p>${requestScope['javax.servlet.error.message']}</p>
    
    <h4>Additional Information</h4>
    <ul>
        <li>Status Code: ${requestScope['javax.servlet.error.status_code']}</li>
        <li>Exception Type: ${requestScope['javax.servlet.error.exception_type']}</li>
        <li>Request URI: ${requestScope['javax.servlet.error.request_uri']}</li>
    </ul>
</div>

<%@ include file="common/footer.jspf"%>
