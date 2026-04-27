// 模拟数据

export const banners = [
  { id: 1, title: '财资API开放平台', subtitle: '提供标准化的访问接口，帮助合作伙伴快速接入', color: '#1a56db' },
  { id: 2, title: '安全可靠的金融服务', subtitle: '多重加密保障，数据安全无忧', color: '#0f766e' },
  { id: 3, title: '丰富的API产品矩阵', subtitle: '覆盖账户、转账、投资、融资等全场景', color: '#7c3aed' }
]

export const productModules = [
  { id: 1, name: '账户管理', icon: '🏦', desc: '账户查询、余额、交易明细等接口', route: '/docs' },
  { id: 2, name: '转账汇款', icon: '💸', desc: '行内转账、跨行转账、批量转账', route: '/docs' },
  { id: 3, name: '投资管理', icon: '📈', desc: '理财产品、基金、国债等接口', route: '/docs' },
  { id: 4, name: '融资管理', icon: '💰', desc: '贷款申请、额度查询、还款计划', route: '/docs' },
  { id: 5, name: '定额票据', icon: '📋', desc: '票据查询、开票、贴现等接口', route: '/docs' },
  { id: 6, name: '外汇业务', icon: '🌐', desc: '汇率查询、外汇买卖、结售汇', route: '/docs' },
  { id: 7, name: '报送业务', icon: '📨', desc: '数据报送、报表生成等接口', route: '/docs' },
  { id: 8, name: '企信服务', icon: '🔍', desc: '企业征信、工商信息查询', route: '/docs' }
]

export const onboardSteps = [
  { step: 1, title: '注册认证', desc: '完成企业信息注册与资质认证', icon: '📝' },
  { step: 2, title: '应用创建', desc: '创建应用获取AppKey和AppSecret', icon: '🔧' },
  { step: 3, title: '产品申请', desc: '选择需要的API产品并提交申请', icon: '📦' },
  { step: 4, title: '开发测试', desc: '使用沙箱环境进行对接开发', icon: '💻' },
  { step: 5, title: '证书申请', desc: '申请数字证书用于生产环境', icon: '🔐' },
  { step: 6, title: '应用上线', desc: '完成验收，正式上线使用', icon: '🚀' }
]

export const docCategories = [
  { key: 'account', label: '账户管理' },
  { key: 'transfer', label: '转账汇款' },
  { key: 'invest', label: '投资管理' },
  { key: 'finance', label: '融资管理' },
  { key: 'bill', label: '定额票据' },
  { key: 'forex', label: '外汇业务' },
  { key: 'report', label: '报送业务' },
  { key: 'credit', label: '企信服务' }
]

export function getMockDocs(category = null) {
  const allDocs = [
    { id: 1, category: 'account', title: '账户信息查询接口文档', fileName: 'AccountQueryAPI_v2.1.pdf', updateTime: '2026-04-08 10:30:00' },
    { id: 2, category: 'account', title: '交易明细查询接口文档', fileName: 'TransactionDetailAPI_v1.5.pdf', updateTime: '2026-04-07 14:20:00' },
    { id: 3, category: 'account', title: '余额通知接口文档', fileName: 'BalanceNotifyAPI_v1.0.pdf', updateTime: '2026-04-05 09:15:00' },
    { id: 4, category: 'transfer', title: '行内转账接口文档', fileName: 'InternalTransferAPI_v2.3.pdf', updateTime: '2026-04-06 16:45:00' },
    { id: 5, category: 'transfer', title: '跨行转账接口文档', fileName: 'CrossBankTransferAPI_v2.0.pdf', updateTime: '2026-04-04 11:30:00' },
    { id: 6, category: 'transfer', title: '批量转账接口文档', fileName: 'BatchTransferAPI_v1.2.pdf', updateTime: '2026-04-03 08:50:00' },
    { id: 7, category: 'invest', title: '理财产品查询接口文档', fileName: 'WealthMgmtAPI_v1.8.pdf', updateTime: '2026-04-02 15:00:00' },
    { id: 8, category: 'finance', title: '贷款申请接口文档', fileName: 'LoanApplyAPI_v1.1.pdf', updateTime: '2026-04-01 10:20:00' },
    { id: 9, category: 'bill', title: '票据查询接口文档', fileName: 'BillQueryAPI_v1.3.pdf', updateTime: '2026-03-30 14:10:00' },
    { id: 10, category: 'forex', title: '汇率查询接口文档', fileName: 'FxRateAPI_v2.5.pdf', updateTime: '2026-03-29 09:30:00' },
    { id: 11, category: 'report', title: '数据报送接口文档', fileName: 'DataReportAPI_v1.0.pdf', updateTime: '2026-03-28 16:00:00' },
    { id: 12, category: 'credit', title: '企业征信查询接口文档', fileName: 'CreditQueryAPI_v1.4.pdf', updateTime: '2026-03-27 11:40:00' }
  ]
  if (category) return allDocs.filter(d => d.category === category)
  return allDocs
}

export function getMockDownloads() {
  return {
    Java: [
      { id: 1, name: 'Java SDK v2.1.0', desc: '核心开发工具包', fileName: 'nbcx-sdk-java-2.1.0.jar', updateTime: '2026-04-08' },
      { id: 2, name: 'Java Demo项目', desc: 'Spring Boot 示例工程', fileName: 'nbcx-demo-java.zip', updateTime: '2026-04-07' },
      { id: 3, name: '签名工具包', desc: '请求签名验签工具', fileName: 'nbcx-sign-java-1.0.jar', updateTime: '2026-04-05' }
    ],
    PHP: [
      { id: 4, name: 'PHP SDK v1.5.0', desc: 'PHP开发工具包', fileName: 'nbcx-sdk-php-1.5.0.tar.gz', updateTime: '2026-04-06' },
      { id: 5, name: 'PHP Demo项目', desc: 'Laravel 示例工程', fileName: 'nbcx-demo-php.zip', updateTime: '2026-04-04' }
    ],
    'C#': [
      { id: 6, name: 'C# SDK v1.2.0', desc: '.NET开发工具包', fileName: 'nbcx-sdk-csharp-1.2.0.nupkg', updateTime: '2026-04-03' },
      { id: 7, name: 'C# Demo项目', desc: 'ASP.NET Core 示例工程', fileName: 'nbcx-demo-csharp.zip', updateTime: '2026-04-01' }
    ]
  }
}

export const mockUsers = [
  { id: 1, type: '行内用户', username: 'zhangsan', role: '行内用户', phone: '--', loginTime: '2026-04-14 18:30:00' },
  { id: 2, type: '行内用户', username: 'lisi', role: '行内用户', phone: '--', loginTime: '2026-04-14 17:20:00' },
  { id: 3, type: '行内用户', username: 'wangwu', role: '行内用户', phone: '--', loginTime: '2026-04-13 15:45:00' },
  { id: 4, type: '行内用户', username: 'zhaoliu', role: '行内用户', phone: '--', loginTime: '2026-04-12 10:10:00' }
]

export const mockLogs = [
  { id: 1, user: 'zhangsan', action: '登录', target: '用户登录', ip: '10.20.30.40', time: '2026-04-14 18:30:00' },
  { id: 2, user: 'zhangsan', action: '下载', target: 'AccountQueryAPI_v2.1.pdf', ip: '10.20.30.40', time: '2026-04-14 18:32:00' },
  { id: 3, user: 'lisi', action: '登录', target: '用户登录', ip: '10.20.30.41', time: '2026-04-14 17:20:00' },
  { id: 4, user: 'lisi', action: '下载', target: 'nbcx-sdk-java-2.1.0.jar', ip: '10.20.30.41', time: '2026-04-14 17:25:00' },
  { id: 5, user: 'wangwu', action: '登录', target: '用户登录', ip: '10.20.30.42', time: '2026-04-13 15:45:00' },
  { id: 6, user: 'wangwu', action: '浏览', target: '文档中心', ip: '10.20.30.42', time: '2026-04-13 15:47:00' }
]
