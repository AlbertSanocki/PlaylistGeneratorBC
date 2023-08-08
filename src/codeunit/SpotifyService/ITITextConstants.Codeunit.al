/// <summary>
/// Codeunit 50103 "ITI Text Constants"
/// This codeunit contains functions to return various text constants.
/// </summary>
codeunit 50103 "ITI Text Constants"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Returns the ID as text.
    /// </summary>
    /// <returns>The ID as text.</returns>
    procedure ID(): Text
    begin
        exit('id')
    end;

    /// <summary>
    /// Returns the name as text.
    /// </summary>
    /// <returns>The name as text.</returns>
    procedure Name(): Text
    begin
        exit('name')
    end;

    /// <summary>
    /// Returns the description as text.
    /// </summary>
    /// <returns>The description as text.</returns>
    procedure Desc(): Text
    begin
        exit('description')
    end;

    /// <summary>
    /// Returns 'public' as text.
    /// </summary>
    /// <returns>'public' as text.</returns>
    procedure Public(): Text
    begin
        exit('public')
    end;

    /// <summary>
    /// Returns the HTTP method 'GET' as text.
    /// </summary>
    /// <returns>The HTTP method 'GET' as text.</returns>
    procedure HttpGET(): Text
    begin
        exit('GET')
    end;

    /// <summary>
    /// Returns the HTTP method 'POST' as text.
    /// </summary>
    /// <returns>The HTTP method 'POST' as text.</returns>
    procedure HttpPOST(): Text
    begin
        exit('POST')
    end;
}