<%@ include file="common/header.jspf" %>
<%@ include file="common/navigation.jspf" %>

<div class="container">
    <h2 class="text-center">List Users</h2>

    <div class="mb-2">
        <a type="button" class="btn btn-primary pull-right" href="/add-user">Create User</a>
    </div>

    <table class="table table-hover table-striped">
        <thead>
            <tr>
                <th>Userid</th>
                <th>Username</th>
                <th>Firstname</th>
                <th>Lastname</th>
                <th>Email</th>
                <th>SSN</th>
                <th>Role</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${users}" var="user">
                <tr>
                    <td>${user.userid}</td>
                    <td>${user.username}</td>
                    <td>${user.firstname}</td>
                    <td>${user.lastname}</td>
                    <td>${user.email}</td>
                    <td>${user.ssn}</td>
                    <td>
                        <a type="button" class="btn btn-primary" href="/update-user?userid=${user.userid}">Update</a>
                    </td>
                    <td>
                        <a type="button" class="btn btn-danger" 
                           href="/delete-user?userid=${user.userid}" 
                           onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="common/footer.jspf" %>
