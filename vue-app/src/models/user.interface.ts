export interface IUser {
    _id? : string;
    task: string;
    memo: string;
    dueDate: string;
    isImportant: boolean;
    isCompleted: boolean;
    priority: string;
    title: string
}