interface IApiResponseBase {
  result: string;
  code?: number | null;
}

export interface IApiResponse<T extends object | null = null> extends IApiResponseBase {
  data?: T;
}

export interface ILLApiResponseRaw {
  result: string;
  error_code?: number | null;
  error_message?: string | null;
  data: Object;
}
