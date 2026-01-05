/**
 * AI 모델 관리 페이지
 * @path /ai-models
 */

'use client';

import { useState, useEffect } from 'react';

interface AIModel {
  id: string;
  name: string;
  version: string;
  type: 'diagnostic' | 'prediction' | 'coaching' | 'anomaly';
  status: 'active' | 'training' | 'testing' | 'archived';
  accuracy: number;
  lastUpdated: string;
  metrics: {
    precision: number;
    recall: number;
    f1Score: number;
  };
}

export default function AIModelsPage() {
  const [models, setModels] = useState<AIModel[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedModel, setSelectedModel] = useState<AIModel | null>(null);

  useEffect(() => {
    const sampleModels: AIModel[] = [
      {
        id: 'm1',
        name: 'MedicalCoach',
        version: '2.3.1',
        type: 'diagnostic',
        status: 'active',
        accuracy: 94.5,
        lastUpdated: '2026-01-03',
        metrics: { precision: 0.95, recall: 0.93, f1Score: 0.94 }
      },
      {
        id: 'm2',
        name: 'HealthPredictor',
        version: '1.8.0',
        type: 'prediction',
        status: 'active',
        accuracy: 89.2,
        lastUpdated: '2026-01-02',
        metrics: { precision: 0.88, recall: 0.91, f1Score: 0.89 }
      },
      {
        id: 'm3',
        name: 'PersonalizedCoach',
        version: '3.0.0',
        type: 'coaching',
        status: 'training',
        accuracy: 91.0,
        lastUpdated: '2026-01-05',
        metrics: { precision: 0.92, recall: 0.90, f1Score: 0.91 }
      },
      {
        id: 'm4',
        name: 'AnomalyDetector',
        version: '2.1.0',
        type: 'anomaly',
        status: 'testing',
        accuracy: 97.8,
        lastUpdated: '2026-01-04',
        metrics: { precision: 0.98, recall: 0.97, f1Score: 0.975 }
      },
      {
        id: 'm5',
        name: 'DiagnosticEngine_v1',
        version: '1.0.0',
        type: 'diagnostic',
        status: 'archived',
        accuracy: 82.3,
        lastUpdated: '2025-11-15',
        metrics: { precision: 0.80, recall: 0.85, f1Score: 0.82 }
      },
    ];
    setModels(sampleModels);
    setLoading(false);
  }, []);

  const typeLabels: Record<string, { label: string; color: string }> = {
    diagnostic: { label: '진단', color: 'bg-blue-600' },
    prediction: { label: '예측', color: 'bg-purple-600' },
    coaching: { label: '코칭', color: 'bg-green-600' },
    anomaly: { label: '이상감지', color: 'bg-red-600' },
  };

  const statusLabels: Record<string, { label: string; color: string }> = {
    active: { label: '활성', color: 'bg-green-500' },
    training: { label: '학습중', color: 'bg-yellow-500' },
    testing: { label: '테스트', color: 'bg-blue-500' },
    archived: { label: '보관', color: 'bg-gray-500' },
  };

  const activeModels = models.filter(m => m.status === 'active');
  const avgAccuracy = activeModels.length > 0
    ? (activeModels.reduce((sum, m) => sum + m.accuracy, 0) / activeModels.length).toFixed(1)
    : 0;

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <h1 className="text-3xl font-bold mb-6">🤖 AI 모델 관리</h1>

      {/* 통계 대시보드 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-r from-cyan-800 to-cyan-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{models.length}</div>
          <div className="text-cyan-200">전체 모델</div>
        </div>
        <div className="bg-gradient-to-r from-green-800 to-green-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{activeModels.length}</div>
          <div className="text-green-200">활성 모델</div>
        </div>
        <div className="bg-gradient-to-r from-purple-800 to-purple-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{avgAccuracy}%</div>
          <div className="text-purple-200">평균 정확도</div>
        </div>
        <div className="bg-gradient-to-r from-amber-800 to-amber-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{models.filter(m => m.status === 'training').length}</div>
          <div className="text-amber-200">학습 진행</div>
        </div>
      </div>

      {/* 모델 그리드 */}
      <div className="grid grid-cols-2 gap-6">
        {models.map((model) => (
          <div 
            key={model.id} 
            className={`bg-gray-800 rounded-lg p-6 cursor-pointer transition-all hover:ring-2 hover:ring-cyan-500 ${
              selectedModel?.id === model.id ? 'ring-2 ring-cyan-500' : ''
            }`}
            onClick={() => setSelectedModel(model)}
          >
            <div className="flex justify-between items-start mb-4">
              <div>
                <h3 className="text-xl font-bold">{model.name}</h3>
                <p className="text-gray-400">v{model.version}</p>
              </div>
              <div className="flex gap-2">
                <span className={`px-2 py-1 rounded text-xs ${typeLabels[model.type].color}`}>
                  {typeLabels[model.type].label}
                </span>
                <span className={`px-2 py-1 rounded text-xs ${statusLabels[model.status].color}`}>
                  {statusLabels[model.status].label}
                </span>
              </div>
            </div>

            {/* 정확도 게이지 */}
            <div className="mb-4">
              <div className="flex justify-between text-sm mb-1">
                <span>정확도</span>
                <span className="font-bold">{model.accuracy}%</span>
              </div>
              <div className="h-3 bg-gray-700 rounded-full overflow-hidden">
                <div 
                  className={`h-full rounded-full transition-all ${
                    model.accuracy >= 90 ? 'bg-green-500' : 
                    model.accuracy >= 70 ? 'bg-yellow-500' : 'bg-red-500'
                  }`}
                  style={{ width: `${model.accuracy}%` }}
                />
              </div>
            </div>

            {/* 메트릭스 */}
            <div className="grid grid-cols-3 gap-4 text-center">
              <div>
                <div className="text-lg font-bold text-blue-400">{(model.metrics.precision * 100).toFixed(0)}%</div>
                <div className="text-xs text-gray-400">Precision</div>
              </div>
              <div>
                <div className="text-lg font-bold text-green-400">{(model.metrics.recall * 100).toFixed(0)}%</div>
                <div className="text-xs text-gray-400">Recall</div>
              </div>
              <div>
                <div className="text-lg font-bold text-purple-400">{(model.metrics.f1Score * 100).toFixed(0)}%</div>
                <div className="text-xs text-gray-400">F1 Score</div>
              </div>
            </div>

            <div className="mt-4 pt-4 border-t border-gray-700 flex justify-between items-center">
              <span className="text-sm text-gray-400">최종 업데이트: {model.lastUpdated}</span>
              <div className="flex gap-2">
                <button className="px-3 py-1 bg-gray-600 hover:bg-gray-500 rounded text-sm">
                  재학습
                </button>
                <button className="px-3 py-1 bg-cyan-600 hover:bg-cyan-500 rounded text-sm">
                  배포
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* 모델 비교 차트 */}
      <div className="mt-6 bg-gray-800 rounded-lg p-6">
        <h2 className="text-xl font-bold mb-4">📈 모델 성능 비교</h2>
        <div className="space-y-4">
          {models.filter(m => m.status !== 'archived').map((model) => (
            <div key={model.id} className="flex items-center gap-4">
              <div className="w-32 truncate">{model.name}</div>
              <div className="flex-1 h-8 bg-gray-700 rounded-full overflow-hidden relative">
                <div 
                  className="absolute inset-y-0 left-0 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-full"
                  style={{ width: `${model.accuracy}%` }}
                />
                <span className="absolute inset-0 flex items-center justify-center text-sm font-bold">
                  {model.accuracy}%
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
