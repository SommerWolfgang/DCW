table 6086017 "CDC Msg. Center Setup Template"
{
    Caption = 'Message Center Setup';

    fields
    {
        field(1; "Message Center ID"; Code[50])
        {
            Caption = 'Message Center ID';
            NotBlank = true;
        }
        field(2; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
        }
        field(4; "Comment Type"; Option)
        {
            Caption = 'System Defined Type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;
        }
        field(5; "Comment (Example)"; Text[250])
        {
            Caption = 'Comment (example)';
        }
        field(6; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Capture,Validation,Processing,Match,Import';
            OptionMembers = Capture,Validation,Processing,Match,Import;
        }
        field(7; "Information Allowed"; Boolean)
        {
            Caption = 'Information Allowed';
        }
        field(8; "Warning Allowed"; Boolean)
        {
            Caption = 'Warning Allowed';
        }
        field(9; "Error Allowed"; Boolean)
        {
            Caption = 'Error Allowed';
        }
        field(10; "User Defined Comment Type"; Option)
        {
            Caption = 'User Defined type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;

            trigger OnValidate()
            begin
                case "User Defined Comment Type" of
                    "User Defined Comment Type"::Information:
                        if not "Information Allowed" then
                            Error(CommentTypeNotAllowed, Format("User Defined Comment Type"));
                    "User Defined Comment Type"::Warning:
                        if not "Warning Allowed" then
                            Error(CommentTypeNotAllowed, Format("User Defined Comment Type"));
                    "User Defined Comment Type"::Error:
                        if not "Error Allowed" then
                            Error(CommentTypeNotAllowed, Format("User Defined Comment Type"));
                end;

                if (xRec."User Defined Comment Type" = xRec."User Defined Comment Type"::Error) and ("User Defined Comment Type" <> "User Defined Comment Type"::Error) then begin
                    "Delegated To User ID" := '';
                    "Create Delegate Comt. On Error" := false;
                end;
            end;
        }
        field(11; "Create Delegate Comt. On Error"; Boolean)
        {
            Caption = 'Assign on Error';

            trigger OnValidate()
            begin
                TestField("User Defined Comment Type", "User Defined Comment Type"::Error);
                if not "Create Delegate Comt. On Error" then
                    "Delegated To User ID" := '';
            end;
        }
        field(12; "Template No."; Code[20])
        {
            Caption = 'Template No.';
        }
        field(13; "Delegated To User ID"; Code[50])
        {
            Caption = 'Assign to User ID';
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                TestField("Create Delegate Comt. On Error", true);
            end;
        }
    }

    keys
    {
        key(Key1; "Message Center ID", "Template No.")
        {
            Clustered = true;
        }
        key(Key2; "Template No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CommentTypeNotAllowed: Label 'Comment Type "%1" is not allowed.';


    procedure GetMsgCenterSetup(MsgCenterID: Code[50]; CommentType: Integer; InfoAllowed: Boolean; WarningAllowed: Boolean; ErrorAllowed: Boolean; Comment: Text[250]; TemplateNo: Code[20])
    begin
        // Template specific Message Center setup has already been created
        if Get(MsgCenterID, TemplateNo) then exit;


        if not Get(MsgCenterID) then begin
            "Message Center ID" := MsgCenterID;
            "Comment Type" := CommentType;
            "Comment (Example)" := Comment;

            "Information Allowed" := InfoAllowed;
            "Warning Allowed" := WarningAllowed;
            "Error Allowed" := ErrorAllowed;
            "User Defined Comment Type" := "Comment Type";
            Insert();
        end else begin
            if ("Information Allowed" <> InfoAllowed) or ("Warning Allowed" <> WarningAllowed) or ("Error Allowed" <> ErrorAllowed) then begin
                "Information Allowed" := InfoAllowed;
                "Warning Allowed" := WarningAllowed;
                "Error Allowed" := ErrorAllowed;

                case "User Defined Comment Type" of
                    "User Defined Comment Type"::Error:
                        if not ErrorAllowed then
                            "User Defined Comment Type" := "Comment Type";
                    "User Defined Comment Type"::Warning:
                        if not "Warning Allowed" then
                            "User Defined Comment Type" := "Comment Type";
                    "User Defined Comment Type"::Information:
                        if not InfoAllowed then
                            "User Defined Comment Type" := "Comment Type";
                end;
                Modify();
            end;
        end;
    end;


    procedure CreateTemplSpecificMstSetup(TemplateNo: Code[20]; MsgCenterID: Text[250]; RemoteMsgCentup: Record "CDC Msg. Center Setup Template")
    var
        FromMsgCentup: Record "CDC Msg. Center Setup Template";
        ToMsgCentup: Record "CDC Msg. Center Setup Template";
    begin
        if MsgCenterID <> '' then
            FromMsgCentup.SetRange("Message Center ID", MsgCenterID);

        FromMsgCentup.SetRange("Template No.", '');
        if FromMsgCentup.FindSet() then
            repeat
                Clear(ToMsgCentup);
                ToMsgCentup := FromMsgCentup;
                ToMsgCentup."Template No." := TemplateNo;
                ToMsgCentup."User Defined Comment Type" := RemoteMsgCentup."User Defined Comment Type";
                ToMsgCentup."Create Delegate Comt. On Error" := RemoteMsgCentup."Create Delegate Comt. On Error";
                ToMsgCentup."Delegated To User ID" := RemoteMsgCentup."Delegated To User ID";
                if not ToMsgCentup.Insert() then
                    ToMsgCentup.Modify();
            until FromMsgCentup.Next() = 0;
    end;
}

